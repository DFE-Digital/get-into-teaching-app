## Mac Setup (as of Catalina 11-07-20)

1. install homebrew, this will ask to install the xcode command line tools if you dont have it already
Run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
2. install gpg2
Run `brew install gpg2`
3. import the RVM keys *do not use these keys* get them from the official website (https://rvm.io/rvm/security) as they change often
Run `gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB`
4. trust the first key
Run `echo 409B6B1796C275462A1703113804BB82D39DC0E3:6: | gpg2 --import-ownertrust # mpapis@gmail.com`
5. install rvm
Run `\curl -sSL https://get.rvm.io | bash -s stable`
6. enable rvm (replace <your-user-name>)
Run `source /Users/<your-user-name>/.rvm/scripts/rvm`
7. install ruby 3.1.2
Run `rvm install ruby 3.1.2`
8. switch your system to use ruby 3.1.2`
Run `rvm use 3.1.2`
9. install yarn
Run `brew install yarn`
10. install the bundler gem
Run `gem install bundler:2.2.8`
