# 📝 Summary of our Picard + Nextflow TMP‑file experiments

## Background & problem: 
Picard’s MarkDuplicates (and similar tools) can spill tens of gigabytes of temporary data; if this bursty I/O lands on the shared NFS/Lustre work directory it risks overlay‑on‑NFS failures, while leaving Picard at its default (/tmp on each node) can just as easily fill a small tmpfs or OS disk and crash the job—either way the default paths are unsafe for large BAMs in a multi‑user cluster.

## experiments
| #     | Config                                                                           | Command used to watch       | What appeared                                                                                                  | Why / lesson                                                            |
| ----- | -------------------------------------------------------------------------------- | --------------------------- | -------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| **A** | *No scratch*, `docker.temp` **unset**                                            | `watch ls /tmp`             | Nothing; Picard spill files were inside Docker’s hidden overlay .     |                           |
| **B** | *No scratch*, `docker.temp='/tmp'`                                               | `watch ls /tmp`             | see Short‑lived files:<br>`libgkl_compression…​.so` (GKL lib) <br>`CSPI.tmp12345/` (spill dir)                     | Host `/tmp` is bind‑mounted; spill files now visible.                   |
| **C** | `scratch true`,  `TMPDIR` **unset**                                           | `watch ls /tmp`             | Saw `/tmp/nxf.XYZ/` (dir) when listing *recursively*; inside it `tmp_dir/` & Picard `sortingcollection.*.tmp`. | Scratch sub‑dir sits *under* `/tmp`  |
| **D** | `scratch true` ,    `export TMPDIR=/my/tmp/path`                                                               | `watch ls /my/tmp/path`             | Same path as C              | scatch use TMPDIR as default path , mount with `containerOptions  = "-v /my/tmp/path:/my/tmp/path "` is not needed       | 

## conclusion
use `scratch true` and `picard --TMP_DIR tmp_dir` , together with `$TMPDIR`

```
process  {
    scratch true
  
    script:
    """
    mkdir -p tmp_dir
    sleep 5   
    picard \\
        -Xmx${avail_mem}M \\
        MarkDuplicates \\
        $args \\
        --INPUT ${params.bam} \\
        --OUTPUT out.bam \\
        --METRICS_FILE MarkDuplicates.metrics.txt \\
        --TMP_DIR tmp_dir
    """
}
```

## take away
- Picard use /tmp as default and never touches NXF_TEMP
- scratch true is preferred on shared‑filesystem clusters for picard process, it moves the entire task sandbox to node‑local storage 
- with scratch true no additional mount needed
- picard deletes tmp files, also when the process breaks with `ctrl-c`
- the experiments were monitored with e.g `watch -n1 ls /tmp/nxf.pevUr7eBMu/tmp_dir/`