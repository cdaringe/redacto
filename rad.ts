import { Task, Tasks } from "https://deno.land/x/rad@v3.0.1/src/mod.ts";

const test = `dune test`;
const format: Task = {
  target: "phony",
  prereqs: ["*.ml"],
  async onMake({ logger, sh }, { getChangedPrereqFilenames }) {
    const reqs = await getChangedPrereqFilenames();
    await Promise.all(
      reqs.map((req) =>
        sh(`ocamlformat -i --enable-outside-detected-project ${req}`)
      )
    );
  },
};

const build = "dune build redacto.exe";

export const tasks: Tasks = {
  b: build,
  build,
  f: format,
  format,
  t: test,
  test,
};
