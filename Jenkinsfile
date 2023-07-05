pipeline { 
  agent any  

    stages { 

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
