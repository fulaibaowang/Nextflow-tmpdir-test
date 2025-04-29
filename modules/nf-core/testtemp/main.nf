process TESTTEMP {

    // tag 'picard-scratch-demo'
    // scratch true          // run inside node-local scratch ($TMPDIR or mktemp)
    // echo    true          // print every command that runs
    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/picard:3.3.0--hdfd78af_0' :
        'biocontainers/picard:3.3.0--hdfd78af_0' }"

    script:
    """
    echo "Process work dir : \$PWD"
    echo "NXF_TEMP         : \$NXF_TEMP"
    echo "TMPDIR           : \$TMPDIR"

    """
}
