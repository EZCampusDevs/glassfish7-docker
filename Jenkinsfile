pipeline { 
  agent any  

    stages { 
        stage('Export Credentials') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'MYSQL_USER_PASS_1', passwordVariable: 'MS1_PASSWORD', usernameVariable: 'MS1_USERNAME')]) {
                    // Write the bash script to a file
                    writeFile file: 'exportCredentials.sh', text: """
                    #!/bin/bash
                    export MS1_USERNAME=${MS1_USERNAME}
                    export MS1_PASSWORD=${MS1_PASSWORD}
                    """

                    // Add execute permissions to the script
                    sh 'chmod +x exportCredentials.sh'
                    // Run the bash script
                    sh './exportCredentials.sh'
                }
            }
        }

      stage('Build Docker Container') { 

        steps { 

          sshPublisher(
              publishers: [
              sshPublisherDesc(
                configName: '2GB_Glassfish_VPS',
                transfers: [
                sshTransfer(cleanRemote: false,
                  excludes: '', 
                  execCommand: '''
                  git clone https://github.com/EZCampusDevs/glassfish7-docker
                  cd glassfish7-docker
                  git pull

                  chmod +x install.sh
                  ./install.sh

                  chmod +x build.sh
                  ./build.sh USE_LOG_FILE ~/warbuilds

                  ''', 
                  execTimeout: 120000, 
                  flatten: false,
                  makeEmptyDirs: false,
                  noDefaultExcludes: false,
                  patternSeparator: '[, ]+', 
                  remoteDirectory: './warbuilds',
                  remoteDirectorySDF: false,
                  removePrefix: '',
                  sourceFiles: '')
                    ], 
                    usePromotionTimestamp: false,
                    useWorkspaceInPromotion: false,
                    verbose: false)
                      ]
                      )  
        }
      }
    }


  post {
    always {
      discordSend(
          description: currentBuild.result, 
          enableArtifactsList: false, 
          footer: '', 
          image: '', 
          link: '', 
          result: currentBuild.result, 
          scmWebUrl: '', 
          thumbnail: '', 
          title: env.JOB_BASE_NAME, 
          webhookURL: "${DISCORD_WEBHOOK_1}"
          )
    }
  }
}
