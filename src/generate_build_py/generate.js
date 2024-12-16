import { parse as parse_jsonc } from "jsr:@std/jsonc@^1.0.1";

if (Deno.args.len < 3) {
  console.log(
    "Not enough arguments. Args: <output_path> <step_defs_jsonc> <python_template>",
  );
  Deno.exit(1);
}

console.log("Generating build.py");

const quote_character = String.fromCharCode(34);

const build_py_path = Deno.args[0].trim();
const step_defs_path = Deno.args[1].trim();
const py_template_path = Deno.args[2].trim();

const step_defs = parse_jsonc(await Deno.readTextFile(step_defs_path));
const py_template = await Deno.readTextFile(py_template_path);

const build_py = await Deno.create(build_py_path);
const build_py_writer = build_py.writable.getWriter();
const encoder = new TextEncoder();

async function write_to_writer(writer, text) {
  const encoded_text = encoder.encode(text);
  await writer.write(encoded_text);
}

const py_template_lines = py_template.split("\n");

for (const line of py_template_lines) {
  await write_to_writer(build_py_writer, line);
  await write_to_writer(build_py_writer, "\n");
}

for (const step of step_defs) {
  await write_to_writer(build_py_writer, "\n");
  await write_to_writer(build_py_writer, "# ");
  await write_to_writer(build_py_writer, JSON.stringify(step));
  await write_to_writer(build_py_writer, "\n");
  await write_to_writer(build_py_writer, "tools.run(");
  await write_to_writer(build_py_writer, quote_character);
  await write_to_writer(build_py_writer, step.cwd);
  await write_to_writer(build_py_writer, quote_character);
  await write_to_writer(build_py_writer, ", ");
  await write_to_writer(build_py_writer, quote_character);
  await write_to_writer(build_py_writer, step.cmd);
  await write_to_writer(build_py_writer, quote_character);
  await write_to_writer(build_py_writer, ")");
  await write_to_writer(build_py_writer, "\n");
}

build_py.close();
console.log("Successfully generated build.py");
