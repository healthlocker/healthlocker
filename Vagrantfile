# detailed instructions for installing
$script = <<SCRIPT

sudo -i
# update ubuntu (security etc.)
apt-get update

# curl
apt-get install curl -y

# nodejs
apt-get -y install g++ git git-core nodejs npm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash && source .bashrc
nvm install node
node -v

# PostgreSQL
apt-get install postgresql postgresql-contrib -y
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
# Confirm Postgres is running:
/etc/init.d/postgresql status

# erlang
apt-get install erlang -y

# elixir
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install esl-erlang -y
apt-get install elixir

# install erlang-odbc
apt-get install erlang-odbc -y

# hex
mix local.hex --force

# phoenix
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

apt-get install inotify-tools -y

curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get install msodbcsql -y
apt-get install unixodbc-utf16 unixodbc-dev-utf16 -y
# # optional: for bcp and sqlcmd
ACCEPT_EULA=Y apt-get install mssql-tools -y
# Add tools to path
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
# optional: for unixODBC development headers
apt-get install unixodbc-dev -y

cd /home/ubuntu/healthlocker


mix local.rebar --force
mix deps.clean --all
mix deps.get --force
mix deps.compile
mix ecto.create -r Healthlocker.Repo
mix ecto.migrate -r Healthlocker.Repo
mix run priv/repo/seeds.exs
mix phoenix.server

SCRIPT


Vagrant.configure("2") do |config|

  # config.vm.box = "base"
  config.vm.box = "ubuntu-xenial-server"
  config.vm.box_url = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box"
  config.vm.box_check_update = true

  config.vm.network :forwarded_port, guest: 4000, host: 4000
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.provision "file", source: "Your path to healthlocker here", destination: "healthlocker"
  config.vm.provision :shell, :inline => $script

end
