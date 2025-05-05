source /home/yun/miniconda3/bin/activate
conda activate nextflow_flo
nextflow run  ~/Nextflow-tmpdir-test/main.nf  -profile conda,test --outdir ~/Nextflow-tmpdir-test-output -work-dir ~/Nextflow-tmpdir-test-output/work -resume
conda deactivate