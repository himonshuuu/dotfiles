# My nixos config

## Usage

### Building the system

```bash
# Build and switch to the new configuration
sudo nixos-rebuild switch --flake .#nixos

# Build without switching (dry run)
sudo nixos-rebuild build --flake .#nixos
```

### Updating the system

```bash
# Update flake inputs
nix flake update

# Rebuild with updated inputs
sudo nixos-rebuild switch --flake .#nixos
```

### Development shell

```bash
# Enter development shell with Nix tooling
nix develop
```

## Customization

### Adding new modules

1. Create a new `.nix` file in the appropriate `modules/` subdirectory
2. Import the module in `config.nix` (for system modules) or `home.nix` (for user modules)
3. Rebuild the system
