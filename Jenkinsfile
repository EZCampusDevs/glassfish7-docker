pipeline { 
  agent any  

    stages { 
        stage('Export Credentials') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'MYSQL_USER_PASS_1', passwordVariable: 'MS1_PASSWORD', usernameVariable: 'MS1_USERNAME')]) {
                    // Write the bash script to a file
                    writeFile file: './token.json', text: """{
  "username" : "${MS1_USERNAME}",
  "password" : "${MS1_PASSWORD}",
  "host" : "mysql-instance",
  "port" : "3306",
  "db_name" : "ezcampus_db"
}
"""
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
                  cd ~/pipeline_glassfish_build
                  
                  git clone https://github.com/EZCampusDevs/glassfish7-docker

                  mv ./token.json glassfish7-docker
                  
                  cd glassfish7-docker
                  git pull
                  
                  chmod +x install.sh
                  ./install.sh

                  chmod +x build.sh
                  ./build.sh USE_LOG_FILE ~/warbuilds

                  chmod +x deploy.sh
                  ./deploy.sh USE_LOG_FILE
                  ''', 
                  execTimeout: 120000, 
                  flatten: false,
                  makeEmptyDirs: false,
                  noDefaultExcludes: false,
                  patternSeparator: '[, ]+', 
                  remoteDirectory: 'pipeline_glassfish_build',
                  remoteDirectorySDF: false,
                  removePrefix: '',
                  sourceFiles: 'token.json')
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
