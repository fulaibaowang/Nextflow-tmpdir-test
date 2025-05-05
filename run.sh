#  export NXF_TEMP=/home/yun/tmp

 nextflow run  ~/Nextflow-tmpdir-test/main.nf  -profile docker,test --outdir ~/Nextflow-tmpdir-test-output -work-dir ~/Nextflow-tmpdir-test-output/work  -resume