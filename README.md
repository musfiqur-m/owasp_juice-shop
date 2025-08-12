# Deploy Juice shop application on VMware using Jenkins - DevSecOps Project!

### **Phase 1: Initial Setup and Deployment**

**Step 1: Launch VMware (Ubuntu 22.04/24.04):**

- Create and Launch Virtual Machine (Ubuntu 24.04/22.04): (CPU: 4 Cores, RAM: 8 GB)
- Connect to the instance using SSH.


**Step 2: Install the Update:**

- Update all the packages and then clone the code.
    
    ```bash
    sudo apt update
    sudo apt upgrade
    ```
- Install Git

    ```bash
    sudo apt install git-all
    ```
**Step 3: Clone the Code:**

- Update all the packages and then clone the code.
- Clone your application's code repository onto the VM instance:
    
    ```bash
    git clone https://github.com/musfiqur-m/owasp_juice-shop
    ```
    
### **Phase 2: Security tools installation**

**Step 1: Install Docker:**

- Install Docker
    
    ```bash
    sudo apt-get update
	sudo apt-get install docker.io -y
	sudo usermod -aG docker $USER
	newgrp docker
	sudo chmod 777 /var/run/docker.sock
    ```

**Step 2: Install SonarQube on the VM instance to scan vulnerabilities:**

- Install Sonarqube using docker
    
    ```bash
    docker run -d --name sonar -p 9000:9000 sonarqube
    ```

**To access**

- YourIP:9000 (by default username & password is admin), now you can change the password. In our case, its 123456
- 𝑆𝑜𝑛𝑎𝑟𝑄𝑢𝑏𝑒 𝐷𝑎𝑠ℎ𝑏𝑜𝑎𝑟𝑑 → 𝑀𝑎𝑛𝑢𝑎𝑙𝑙𝑦 → 𝑃𝑟𝑜𝑗𝑒𝑐𝑡 𝐷𝑖𝑠𝑝𝑙𝑎𝑦 𝑁𝑎𝑚𝑒 𝑎𝑛𝑑 𝑘𝑒𝑦 (𝐽𝑢𝑖𝑐𝑒 −
𝑠ℎ𝑜𝑝) → 𝑆𝑒𝑡𝑢𝑝 → 𝐿𝑜𝑐𝑎𝑙𝑙𝑦 → 𝐺𝑒𝑛𝑒𝑟𝑎𝑡𝑒 → 𝐶𝑜𝑛𝑡𝑖𝑛𝑢𝑒 → 𝑂𝑡ℎ𝑒𝑟𝑠 → 𝐿𝑖𝑛𝑢𝑥.


**Step 3: Install Trivy on the VM instance to scan for vulnerabilities:**

- Install Trivy
    ```bash
    sudo apt-get install wget apt-transport-https gnupg lsb-release
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
    echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
    sudo apt-get update
	sudo apt-get install trivy
    ```
**To scan image using trivy**

- trivy image <imageid> #you can find images using docker images

**Step 4: Install CycloneDX:**

- In your Jenkins environment, install the tool globally (or as part of your project’s dependencies) using a command like:

    ```bash
    sudo apt install npm
    sudo npm install -g n
    sudo n 20.18.0
    sudo npm install -g @cyclonedx/cyclonedx-npm
    ```
**Step 5: Install Snyk:**
- Install Snyk
    
    ```bash
    curl https://static.snyk.io/cli/latest/snyk-linux -o snyk
    chmod +x ./snyk
    sudo mv ./snyk /usr/local/bin/  
    ```
**Step 6: Install Java:**

- Install Java
    ```bash
    sudo apt update
    sudo apt install fontconfig openjdk-17-jre
    ```

**Step 7: Install Jenkins:**

- Install Jenkins
    
    ```bash
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
	echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
	sudo apt-get update
    sudo apt-get install jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    ```

**To access**
 - localhost:8080 (find password using this command: sudo cat /var/lib/jenkins/secrets/initialAdminPassword), now you can create an admin user. In our case, it is musfiqur97,7573

**Alternative Installation: All tools using scripts:**

- Change directory to owasp_juice-shop/installation and run the following scripts in the terminal of host system
    
    ```bash
    ./docker.sh
    ./update.sh
    ./sonarqube.sh
	./trivy.sh
    ./cyclonedx.sh
    ./snyk.sh
	./jenkins.sh
    ```

### **Phase 3: Tools plugins installation**
- Install Necessary Plugins in Jenkins:
- Go to "Dashboard" in your Jenkins web interface.
- Navigate to "Manage Jenkins" → "Manage Plugins."
- Click on the "Available" tab
- Goto Manage Jenkins →Plugins → Available Plugins → and search for the following plugins and install:

1. Eclipse Temurin Installer
2. NodeJs Plugin
3. SonarQube Scanner for Jenkins
4. Install Docker Tools and Docker Plugins
    1. Docker
    2. Docker Commons
    3. Docker Pipeline
    4. Docker API
- Click on the "Install without restart" button to install these plugins.
- Click on Apply and Save


### **Phase 4: Credentials and access token ID creation for security tools**

**Step 1: Create the Sonar token:**
- Goto SonarQube Dashboard → Administration → Security → Users → Update Tokens (Under Tokens/Beside Token Number)→ Enter a Name → Generate → Copy it.
- Goto Jenkins Dashboard → Manage Jenkins → Credentials → System → Global credentials (unrestricted) → Add Credentials → Secret text → Paste it in Secret → ID: Sonar−token → Description: Sonar−token → Create.

**Step 2: Create Snyk token:**
- Create an account on apps.snyk.io for the authentication key for sonar token. It will be in the account settings you need to press click to show to get the key.
- Goto Jenkins Dashboard → Manage Jenkins → Credentials → System → Global credentials (unrestricted) → Add Credentials → Secret text → Paste it in Secret → ID: Snyk−token−id → Description: Snyk−token−→Create

**Step 2: Add DockerHub Credentials:**
- Create Docker Hub account at https://hub.docker.com/, we will be using this credential to push the image to docker hub
- To securely handle DockerHub credentials in your Jenkins pipeline, follow these steps:
- Goto Jenkins Dashboard → Manage Jenkins → Credentials → System → Global credentials (unrestricted) → Add Credentials → Username and Password(docker hub) → Paste it in username and Password → ID: docker → Description:docker−→Create

### **Phase 5: Security tolls agent creation in Jenkins**

**Step 1: Configure Java and Nodejs in Global Tool Configuration:**
- Goto Manage Jenkins → Tools → Install JDK(17)→ Name: jdk17 → Mark Install automatically → Install from adoptium.net → version jdk−17.0.8.1+1
- Scroll to NodeJs(16)→ Name: node20 → Mark Install automatically → NodeJS 20.18.2

**Step 2: Configure Setup Sonar Scanner:**
- Goto Jenkins Dashboard → Manage Jenkins → System→ In SonarQube Sever section (Add SonarQube) → Click Enivironment variable→ Name: sonar−server → Server URL: http://YourIP:9000 → Server authentication token: Sonar−token → Apply → Save.
- Goto Manage Jenkins → Tools → SonarQube Scanner installations (Add SonarQube Scanner) → Name: sonar−scanner → Version: 7.0.0.4796 → Apply → Save.

**Step 3: Configure Docker:**
-  Go to "Dashboard" → "Manage Jenkins" → "Global Tool Configuration  → Docker installations → Add the tool's name, e.g., "docker. → Mark Install automatically→ Install from docker.com → Apply → Save.





### **Phase 6: Pipeline Code**


```groovy

pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node20'
    }
    environment {
        SCANNER_HOME=tool 'sonar−scanner'
    }
    stages {
        stage('Clean Workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'master', url: 'https://github.com/musfiqur-m/owasp_juice-shop.git'
            }
        }
        stage('SAST - SonarQube'){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Juice-shop \
                    -Dsonar.projectKey=Juice-shop '''
                }
            }
        }
	
        stage('Generate SBOM - CycloneDX') {
            steps {
                // Install dependencies
                sh "npm install"
                //Generate the SBOM in JSON
                sh 'cyclonedx-npm --output-file sbom.json --output-format JSON'
            }
        }
        stage('SCA - Snyk') {
            steps {
                // Use withCredentials to bind a "Secret text" credential as a string.
                withCredentials([string(credentialsId: 'Snyk−token−id', variable: 'SNYK_TOKEN')]) {
                    sh "snyk auth ${SNYK_TOKEN}"
                    // Adjust the --org flag value to match your Snyk organization.
                    sh "snyk monitor --org=musfiqur-m"
                }
            }
        }
        stage('File System Scan - Trivy') {
            steps {
                sh "trivy fs -f json -o File_System_Scan_Report_Trivy.json ."
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){   
                       // Replace mmusfiqur97 with your docker username
                       sh "docker build --no-cache -t musfiqur97/juice-shop:latest ."
                       sh "docker push musfiqur97/juice-shop:latest"
                    }
                }
            }
        }
        stage("Container Scan - Trivy"){
            steps{
                sh "wget https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl -P contrib/"
                sh "trivy image --format template --template \"@contrib/html.tpl\" -o Container_Scan_Report_Trivy.html musfiqur97/juice-shop:latest" 
            }
        }
        stage('Deploy Container'){
            steps{
                sh 'docker run -d -p 3000:3000 musfiqur97/juice-shop:latest'
            }
        }
        stage('DAST - OWASP ZAP'){
            steps{
                sh "chmod 777 \$(pwd)"
                sh "docker run --rm -v \$(pwd):/zap/wrk/:rw --name owasp -dt zaproxy/zap-stable /bin/bash"
                // Replace YourIP with your VM instance IP 
                sh "docker exec owasp zap-baseline.py -t http://YourIP:3000/ -I -j --auto -r DAST_Report.html"
                sh ''' docker cp owasp:/zap/wrk/DAST_Report.html ${WORKSPACE}/DAST_Report.html '''
                sh "docker stop owasp"
            }
        }
    }
    post {
        always {
            // Archive SBOM, Trivy reports and ZAP report
            archiveArtifacts artifacts: 'sbom.json, File_System_Scan_Report_Trivy.json, Container_Scan_Report_Trivy.html, DAST_Report.html', fingerprint: true
        }
    }
}


```

- If you get docker login failed errorr
```bash
sudo su
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```
