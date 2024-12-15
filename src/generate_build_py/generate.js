import { parse as parse_jsonc } from "jsr:@std/jsonc@^1.0.1";

if (Deno.args.len < 3) {
  console.log(
    "Not enough arguments. Args: <output_path> <step_defs_jsonc> <python_template>",
  );
  Deno.exit(1);
}

console.log("Generating build.py");

const build_py_path = Deno.args[0];
const step_defs_path = Deno.args[1];
const py_template_path = Deno.args[2];

const step_defs = parse_jsonc(await Deno.readTextFile(step_defs_path));
const py_template = await Deno.readTextFile(py_template_path);

const build_py = await Deno.create(build_py_path);
const build_py_writer = build_py.writable.getWriter();
const encoder = new TextEncoder();

await build_py_writer.write(encoder.encode(py_template));

for (const step of step_defs) {
  const statement = `\n# ${JSON.stringify(step)}\ntools.run("${step.cwd}", "${step.cmd}")\n`;
  await build_py_writer.write(encoder.encode(statement));
}

build_py.close();
console.log("Successfully generated build.py");
