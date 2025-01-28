# Check if Docker is installed via snap
if snap list docker &> /dev/null; then
    echo "Error: Docker is installed via snap. Please remove it first with:"
    echo "sudo snap remove docker"
    echo "If the above hangs when creating snapshots, try the following. NOTE ALL DOCKER VOLUMES WILL BE DELETED!"
    echo "sudo snap remove docker --purge"
    exit 1
fi

# Check if Docker is already installed via apt
if command -v docker &> /dev/null && ! snap list docker &> /dev/null; then
    echo "Docker is already installed via apt, all good, nothing to do here."
    # Ensure user is in docker group
    if ! groups $USER | grep -q docker; then
        echo "Adding user to docker group..."
        sudo usermod -aG docker $USER
        echo "Please log out and back in for group changes to take effect"
    fi
    exit 0
fi

# Install dependencies
sudo apt update
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to the docker group
sudo usermod -aG docker $USER
