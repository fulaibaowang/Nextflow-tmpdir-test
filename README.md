# 📝 Summary of our Picard + Nextflow TMP‑file experiments

## experiments
| #     | Config                                                                           | Command used to watch       | What appeared                                                                                                  | Why / lesson                                                            |
| ----- | -------------------------------------------------------------------------------- | --------------------------- | -------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| **A** | *No scratch*, `docker.temp` **unset**                                            | `watch ls /tmp`             | Nothing; Picard spill files were inside Docker’s hidden overlay (`/var/lib/docker/overlay2/.../diff/tmp`).     | OverlayFS layer is invisible unless you dig.                            |
| **B** | *No scratch*, `docker.temp='/tmp'`                                               | `watch ls /tmp`             | Short‑lived files:<br>`libgkl_compression…​.so` (GKL lib) <br>`CSPI.tmp12345/` (spill dir)                     | Host `/tmp` is bind‑mounted; spill files now visible.                   |
| **C** | `scratch true`,  `TMPDIR` **unset**                                           | `watch ls /tmp`             | Saw `/tmp/nxf.XYZ/` (dir) when listing *recursively*; inside it `tmp_dir/` & Picard `sortingcollection.*.tmp`. | Scratch sub‑dir sits *under* `/tmp`  |
| **D** | `scratch true` ,    `export TMPDIR=/my/tmp/path`                                                               | `watch ls /my/tmp/path`             | Same path as C              | scatch use TMPDIR as default path , `containerOptions  = "-v /my/tmp/path:/my/tmp/path "` not needed       | 

## take away
- Picard use /tmp as default and never touches NXF_TEMP
- scratch true is preferred on shared‑filesystem clusters 
- with scratch true no additional mount needed
- picard deletes tmp files, also when the process breaks with ctrl-c
- monitor with watch -n1 ls /tmp/nxf.pevUr7eBMu/tmp_dir/