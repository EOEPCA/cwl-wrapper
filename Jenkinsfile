environment {
    PATH = "$WORKSPACE/conda/bin:$PATH"
    CONDA_UPLOAD_TOKEN = credentials('terradue-conda')
  }

pipeline {
    agent {
        docker { image 'docker.terradue.com/conda-build:latest' }
    }
    parameters {
        choice(choices: ['eoepca', 'terradue'], description: 'Where do you want to deploy the package?', name: 'deployDest')
    }
    stages {
        stage('Test') {
            steps {
                sh '''#!/usr/bin/env bash
                conda build --version
                conda --version
                mamba clean -a -y 
                '''
            }
        }
        stage('Build') {
            steps {
                sh '''#!/usr/bin/env bash
                mkdir -p /home/jovyan/conda-bld/work
                cd $WORKSPACE
                mamba build .
                '''
            }
        }
        stage('Deploy') {            
            steps { 
                script{
                    if (params.deployDest == "terradue"){
                        withCredentials([string(credentialsId: 'terradue-conda', variable: 'ANACONDA_API_TOKEN')]) {
                        sh '''#!/usr/bin/env bash
                        export PACKAGENAME=cwl-wrapper
                        label=main
                        if [ "$GIT_BRANCH" = "develop" ]; then label=dev; fi
                        anaconda upload --no-progress --force --user Terradue --label $label /srv/conda/envs/env_conda/conda-bld/*/$PACKAGENAME-*.tar.bz2
                        '''}
                    } else {
                    withCredentials([string(credentialsId: 'eoepca-conda', variable: 'ANACONDA_API_TOKEN')]) {
                        sh '''#!/usr/bin/env bash
                        export PACKAGENAME=cwl-wrapper
                        label=main
                        if [ "$GIT_BRANCH" = "develop" ]; then label=dev; fi
                        anaconda upload --no-progress --force --user eoepca --label $label /srv/conda/envs/env_conda/conda-bld/*/$PACKAGENAME-*.tar.bz2
                        '''}
                    }
                }
            }
        }
    }
}
