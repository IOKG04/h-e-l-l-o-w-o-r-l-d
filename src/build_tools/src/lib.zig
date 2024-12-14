const std = @import("std");
const python = @import("python");

const PyObject = python.PyObject;

const alloc = std.heap.c_allocator;

fn py_run(self: [*c]PyObject, args: [*c]PyObject) callconv(.C) [*]PyObject {
    _ = self;

    var cwd_ptr: [*c]const c_char = null;
    var cwd_len: python.Py_ssize_t = 0;
    var command_ptr: [*c]const c_char = null;
    var command_len: python.Py_ssize_t = 0;

    if (python.PyArg_ParseTuple(
        args,
        "s#s#",
        &cwd_ptr,
        &cwd_len,
        &command_ptr,
        &command_len,
    ) == 0) {
        python.Py_FatalError("Arguments incorrect");
    }

    const cwd: []const u8 = @ptrCast(cwd_ptr[0..@intCast(cwd_len)]);
    const command: []const u8 = @ptrCast(command_ptr[0..@intCast(command_len)]);

    var argv = alloc.alloc([]const u8, 3) catch unreachable;
    defer alloc.free(argv);
    argv[0] = "bash";
    argv[1] = "-ec";
    argv[2] = std.fmt.allocPrint(alloc, "cd {s} ; {s}", .{ cwd, command }) catch unreachable;
    defer alloc.free(argv[2]);

    std.debug.print("\n### Running '{s}' in '{s}' ###\n", .{ command, cwd });

    var child = std.process.Child.init(argv, alloc);
    const term = child.spawnAndWait() catch python.Py_FatalError("Child died unexpectedly");

    switch (term) {
        .Exited => |res| if (res != 0) {
            std.debug.print("### ! '{s}' failed with {d} ! ###\n\n", .{ command, res });
            python.Py_FatalError("Child command failed");
        },
        .Signal => |signal| {
            std.debug.print("### ! '{s}' caught signal {d} ! ###\n\n", .{ command, signal });
            python.Py_FatalError("Child command failed");
        },
        .Stopped, .Unknown => |res| {
            std.debug.print("### ! '{s}' failed in a weird way with {d} ! ###\n\n", .{ command, res });
            python.Py_FatalError("Child command failed");
        },
    }

    return python.Py_BuildValue("");
}

const sentinel_method = python.PyMethodDef{
    .ml_name = null,
    .ml_meth = null,
    .ml_flags = 0,
    .ml_doc = null,
};

var methods = [_:sentinel_method]python.PyMethodDef{
    python.PyMethodDef{
        .ml_name = "run",
        .ml_meth = &py_run,
        .ml_flags = 1,
        .ml_doc = null,
    },
};

var module = python.PyModuleDef{
    .m_base = python.PyModuleDef_Base{
        .ob_base = PyObject{ .ob_type = null, .unnamed_0 = .{
            .ob_refcnt = 1,
        } },
        .m_copy = null,
        .m_init = null,
        .m_index = 0,
    },
    .m_name = "tools",
    .m_size = -1,
    .m_methods = &methods,

    .m_traverse = null,
    .m_clear = null,
    .m_slots = null,
    .m_free = null,
    .m_doc = null,
};

pub export fn PyInit_tools() callconv(.C) [*]PyObject {
    return python.PyModule_Create2(&module, 3);
}
