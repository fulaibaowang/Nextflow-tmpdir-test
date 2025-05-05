process TESTTEMP {
    scratch true
    // params.sleep = 45          // time to watch the dir
    params.bam = '/home/yun/Nextflow-tmpdir-test-output/a2b6c3d9e8f7123456789abcdef0123456789abcdef0123456789abcdef01234_Blood_DNA_normal.bam'
    // params.bam = '/home/yun/Nextflow-tmpdir-test-output/a2b6c3d9e8f7123456789abcdef0123456789abcdef0123456789abcdef01234_Tumor_DNA_sample.bam'
    // tag 'picard-scratch-demo'
    // scratch true          // run inside node-local scratch ($TMPDIR or mktemp)
    // echo    true          // print every command that runs
    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/picard:3.3.0--hdfd78af_0' :
        'biocontainers/picard:3.3.0--hdfd78af_0' }"
    containerOptions  = "-v /home/yun:/home/yun "
    
    beforeScript 'echo "PWD          = \$PWD" && echo "NXF_SCRATCH  = \${NXF_SCRATCH:-<unset>}"'
    
    script:
    

    
    def args = task.ext.args ?: ''
    def avail_mem = 3072
    if (!task.memory) {
        log.info '[Picard MarkDuplicates] Available memory not known - defaulting to 3GB. Specify process memory requirements to change this.'
    } else {
        avail_mem = (task.memory.mega*0.8).intValue()
    }

    """
    mkdir -p tmp_dir
    echo "Process work dir : \$PWD"
    #echo "NXF_TEMP         : \$NXF_TEMP"
    #echo "TMPDIR           : \$TMPDIR"
    echo "Temp dir is: \$PWD/tmp_dir"
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
