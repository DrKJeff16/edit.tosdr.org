#/bin/bash

# Welcome message.

echo -e "\n[*] Welcome to the installer for \`edit.tosdr.org\`!\n\n    ###############\n    ###############\n    ###########          'I have read and agreed to the Terms'\n    ###########          is the biggest lie on the web.\n    #######\n    #######              We aim to fix that.\n\n"

# Checks whether curl is installed
# installs it if not.

echo
sleep 1.5s
echo -e "\n\n[*] Checking whether \`curl\` is installed..."
sleep 1s
if apt list | grep "curl" 2> /dev/null ; then
  sleep .75s
  echo -e "\n    - \`curl\` is installed!\n"
  sleep 1s
else
  sleep .75s
  echo -e "  No.\n"
  sleep .75s
  echo -e "[*] Installing \`curl\`..."
  sleep 1s
  sudo apt-get install curl && sleep 1s && echo -e "\n\`curl\` has been successfully installed!"
fi

# Checks for rbenv, installs it if not found.

echo
sleep 1.5s
export PATH=$PATH:$HOME/.rbenv/bin
echo -e "[*] Checking if you have \`rbenv\` installed..."
sleep 1s
if [ -d ~/.rbenv/plugins/ruby-build ] ; then
  sleep .75s
  echo -e "    - You have \`rbenv\` installed!\n"
  sleep 1s
else
  sleep .75s
  echo "  No.\n"
  sleep .75s
  echo "[*] Installing \`rbenv\`..."
  sleep 1s
  export PATH=$PATH:$HOME/.rbenv/shims                  # Some environments are not parsing the export correctly due to the quotes. Removed for that reason.
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash && echo -e "\n\n\`rbenv\` has been installed successfully!"
fi

# Sets rbenv in the background.

echo
sleep 1.5s
echo -e "[*] Setting up \`rbenv\` in your shell..."
sleep 1s
echo
sleep 1s
echo -e "\n\n[*] Setting \`eval \"\$(rbenv init -)\"\`..."
sleep 1s
echo
eval "$(rbenv init -)" && sleep 1s && echo -e "\n\n[*] Done.\n"

# Checks for the current version of Ruby,
# installs it if it's other than 2.7.2.

echo
sleep 1.5s
echo -e "\n[*] Checking your version of Ruby..."
sleep 1s
echo
if rbenv versions --bare | grep -q 2.7.2 2> /dev/null ; then
  sleep .75s
  echo -e "    - You already have Ruby 2.7.2!\n"
  sleep 1s
else
  sleep .75s
  echo -e "  No.\n"
  sleep .75s
  echo
  echo -e "[*] Installing Ruby 2.7.2..."
  sleep 1s
  echo
  sleep .75s
  echo -e "    This might take a while...\n"
  sleep .75s
  rbenv install 2.7.2 && echo -e "\n\nRuby 2.7.2 has been installed successfully!\n"
fi

# Checks whether yarn is installed,
# installs it if not found.

echo
sleep 1.5s
echo -e "\n[*] Checking whether you have \`yarn\` installed..."
sleep 1s
echo
if hash yarn 2>/dev/null ; then
  sleep .75s
  echo "    - You have \`yarn\` installed!\n"
  sleep 1s
else
  sleep .75s
  echo -e "  No.\n"
  sleep .75s
  echo -e "[*] Installing \`yarn\`...\n"
  sleep .75s
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  sleep .75s
  echo
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sleep .75s
  sudo apt-get update
  sleep .75s
  sudo apt-get install yarn && sleep 1s && echo -e "\n\nSuccess!\n"
fi

# Checks for postgres (psql) on the system,
# installs it if not found.

echo
sleep 1.5s
echo -e "\n[*] Checking whether you have \`postgres\` installed..."
if hash psql 2> /dev/null ; then
  sleep .75s
  echo -e "    - You have \`postgres\` installed!\n"
  sleep 1s
else
  sleep .75s
  echo "  No.\n"
  sleep .75s
  echo -e "\n[*] Installing postgres...\n"
  sleep .75s
  echo
  sudo apt-get install postgresql postgresql-contrib libpq-dev build-essential -y && echo -e "\n\nSuccess!\n"
  sleep 1s
  # TODO: find a way to setup postgres for the user
  #echo `whoami` > /tmp/caller
  #sudo su - postgres
  #psql --command "CREATE ROLE `cat /tmp/caller` LOGIN createdb;"
  #exit
  #rm -f /tmp/caller
fi

# Checks whether phantomjs is installed,
# Installs it if not.

echo
sleep 1.5s
echo -e "\n[*] Checking whether you have \`phantomjs\` installed..."
sleep 1s
if command -v phantomjs > /dev/null ; then
  sleep .75s
  echo "    - You have \`phantomjs\` installed!\n"
  sleep 1s
else
  sleep .75s
  echo -e "  No.\n"
  sleep 1s
  echo -e "\n[*] Installing \`phantomjs\`...\n"
  sleep 1s
  echo
  sudo apt-get -y install phantomjs
fi

echo
sleep 1.5s
echo -e "[*] Setting local ruby version to 2.7.2...\n"
sleep 1.5s
echo
rbenv local 2.7.2 && sleep 1s && echo -e "\nDone!"

echo
sleep 1.5s
echo -e "[*] Checking whether you have \`bundler\` installed..."
sleep 1s
if rbenv which bundle 2> /dev/null ; then
  sleep .75s
  echo -e "\n    - You have \`bundler\` installed!\n"
  sleep 1s
else
  sleep .75s
  echo -e "  No.\n"
  sleep .75s
  echo -e "[*] Installing budler..."
  sleep 1s
  gem install bundler && sleep 1s && echo -e "\n\nSuccess!\n"
fi

# Installs the Ruby gems.

sleep 1s
echo
for i in {1..12} ; do
  echo "[*]"
  sleep .2s
done
echo "[*] Installing gems..."
sleep 1s
for i in {1..7} ; do
  echo "[*]"
  sleep .4s
done
sleep 1s
echo
bundle install && echo -e "\nGems installed successfully!"
sleep 1s

# Sets up yarn locally.

echo
for i in {1..12} ; do
  echo "[*]"
  sleep .2s
done
echo -e "[*] Compiling JS..."
sleep 1s
for i in {1..7} ; do
  echo "[*]"
  sleep .4s
done
sleep 1s
echo
yarn install && sleep 1s && echo -e "\nJS Compiled successfully!"
sleep 1s

# Sets up the database locally.

echo
for i in {1..12} ; do
  echo "[*]"
  sleep .2s
done
echo -e "[*] Setting up the database..."
sleep 1s
for i in {1..7} ; do
  echo "[*]"
  sleep .2s
done
sleep 1s
echo
rails db:create db:migrate && echo -e "\n\nDatabase set up successfully!"

sleep 1.5s
echo
sleep 1.5s
echo -e "\n[*] You are ready to go!\n  - Run \"rails server\" to start the server up!"

sleep 2s
echo

# Exit 0 will allow for successful script end, but GNOME
# Terminal closes every time that is executed...

#exit 0

#    ##############
#    ##########
#    #######
