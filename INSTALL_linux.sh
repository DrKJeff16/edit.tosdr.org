#/bin/bash

echo -e "\n[*] Welcome to the installer for \`edit.tosdr.org\`!\n\n    ###############\n    ###############\n    ###########          'I have read and agreed to the Terms'\n    ###########          is the biggest lie on the web.\n    #######\n    #######              We aim to fix that.\n\n"

# Need to add a `curl` checker as not every
# Distro has curl installed...

sleep .5s
echo -e "\n\n[*] Checking whether \`curl\` is installed..."
if apt list | grep "curl" 2> /dev/null ; then
  sleep .5s
  echo -e "\n    - \`curl\` is installed!\n"
else
  sleep .5s
  echo -e "  No.\n"
  sleep .5s
  echo -e "[*] Installing \`curl\`..."
  sudo apt-get install curl && echo -e "\n\`curl\` has been successfully installed!"
fi

# Checks for rbenv, installs if not found.

sleep 1.5s
export PATH=$PATH:$HOME/.rbenv/bin
echo -e "[*] Checking if you have \`rbenv\` installed..."
if [ -d ~/.rbenv/plugins/ruby-build ] ; then
  sleep .5s
  echo -e "    - You have \`rbenv\` installed!\n"
else
  sleep .5s
  echo "  No.\n"
  sleep .5s
  echo "[*] Installing \`rbenv\`..."
  export PATH=$PATH:$HOME/.rbenv/shims                  # Some environments are not parsing the export correctly due to the quotes. Removed for that reason.
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash && echo -e "\n\n\`rbenv\` has been installed successfully!"
fi

sleep 1s
echo -e "[*] Setting up \`rbenv\` in your shell..."
sleep .25s
echo
sleep .25s
echo -e "\n\n[*] Setting \`eval \"\$(rbenv init -)\"\`..."
eval "$(rbenv init -)" && echo -e "\n[*] Done.\n"

sleep .5s
echo -e "\n[*] Checking your version of Ruby..."
if rbenv versions --bare | grep -q 2.7.2 2> /dev/null ; then
  sleep .5s
  echo -e "    - You have Ruby 2.7.2!\n"
else
  sleep .5s
  echo -e "  No.\n"
  sleep .5s
  echo
  echo -e "[*] Installing Ruby 2.7.2..."
  sleep .5s
  echo
  echo -e "    This might take a while...\n"
  sleep .25s
  rbenv install 2.7.2 && echo -e "\n\nRuby 2.7.2 has been installed successfully!\n"
fi

sleep .5s
echo -e "\n[*] Checking whether you have \`yarn\` installed..."
sleep .5s
if hash yarn 2>/dev/null ; then
  sleep .5s
  echo "    - You have \`yarn\` installed!\n"
else
  echo -e "  No.\n"
  echo -e "[*] Installing \`yarn\`...\n"
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && sudo apt-get -y install yarn && echo -e "\nSuccess!\n"
fi

sleep .5s
echo -e "\n[*] Checking whether you have \`postgres\` installed..."
if hash psql 2> /dev/null ; then
  sleep .5s
  echo -e "    - You have \`postgres\` installed!\n"
else
  sleep .5s
  echo "  No.\n"
  sleep .75s
  echo -e "\n[*] Installing postgres...\n"
  sudo apt-get install postgresql postgresql-contrib libpq-dev build-essential -y
  # TODO: find a way to setup postgres for the user
  #echo `whoami` > /tmp/caller
  #sudo su - postgres
  #psql --command "CREATE ROLE `cat /tmp/caller` LOGIN createdb;"
  #exit
  #rm -f /tmp/caller
fi

sleep .5s
echo -e "\n[*] Checking whether you have \`phantomjs\` installed..."
if command -v phantomjs > /dev/null ; then
  sleep .5s
  echo "    - You have \`phantomjs\` installed!\n"
else
  sleep .5s
  echo -e "  No.\n"
  sleep 1s
  echo -e "\n[*] Installing \`phantomjs\`...\n"
  sudo apt-get -y install phantomjs
fi

sleep 1s
echo -e "[*] Setting local ruby version to 2.7.2...\n"
sleep .5s
rbenv local 2.7.2 && echo -e "\nDone!"

sleep .5s
echo -e "[*] Checking whether you have \`bundler\` installed..."
if rbenv which bundle 2&>1 > /dev/null ; then
  sleep .5s
  echo -e "    - You have \`bundler\` installed!\n"
else
  sleep .5s
  echo -e "  No.\n"
  sleep .5s
  echo -e "[*] Installing budler..."
  sleep .75s
  gem install bundler && echo -e "\n\nSuccess!\n"
fi

for i in {1..12} ; do
  echo "[*]"
  sleep .075s
done
echo "[*] Installing gems..."
for i in {1..7} ; do
  echo "[*]"
  sleep .2s
done
bundle install && echo -e "\nGems installed successfully!"
sleep .5s


for i in {1..12} ; do
  echo "[*]"
  sleep .075s
done
echo -e "[*] Compiling JS..."
for i in {1..7} ; do
  echo "[*]"
  sleep .2s
done
yarn install && echo -e "\nJS Compiled successfully!"

for i in {1..12} ; do
  echo "[*]"
  sleep .075s
done
echo -e "[*] Setting up the database..."
for i in {1..7} ; do
  echo "[*]"
  sleep .2s
done
rails db:create db:migrate && echo -e "\n\nDatabase set up successfully!"

sleep .75s
echo
sleep .5s
echo -e "[*] You are ready to go!\n  - Run \"rails server\" to start the server up!"

# Exit 0 will allow for successful script end, but GNOME
# Terminal closes every time that is executed...

#exit 0
