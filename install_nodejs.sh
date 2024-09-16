echo "INSTALL NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

echo "SOURCE BASH"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Ini memastikan nvm dapat diakses

# download and install Node.js (you may need to restart the terminal)
echo "INSTALL NPM V20"
nvm install 20
# verifies the right Node.js version is in the environment
node -v # should print `v20.17.0`
# verifies the right npm version is in the environment
npm -v # should print `10.8.2`

echo "INSTALL NODE JS & NODE SUCCESSFULLY"

echo "TEST WITH EXAMPLE APPLICATION"

cd example-apps/nodejs && npm install && npm run dev

echo "RUNNING IN PORT {public ip}:10001"


