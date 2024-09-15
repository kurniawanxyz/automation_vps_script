echo "INSTALL NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

echo "SOURCE BASH"
source ~/.bashrc

# download and install Node.js (you may need to restart the terminal)
echo "INSTALL NPM V20"
nvm install 20
# verifies the right Node.js version is in the environment
node -v # should print `v20.17.0`
# verifies the right npm version is in the environment
npm -v # should print `10.8.2`

echo "INSTALL NODE JS & NODE SUCCESSFULLY"
