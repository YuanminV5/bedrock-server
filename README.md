
###Start the server:
   ```bash
   docker-compose up -d
   ```

###Stop the server:
   ```bash
   docker-compose down
   ```


## Configuration

### Server Properties

To customize your server, you can modify the `server.properties` file. After the first run, copy the default configuration:

```bash
# Copy default server.properties from container
docker cp minecraft-bedrock:/minecraft-bedrock/server.properties ./config/

# Edit the configuration
nano ./config/server.properties

# Restart the container to apply changes
docker-compose restart
```

### Important Configuration Options

- `server-name`: The name of your server
- `gamemode`: Default game mode (survival, creative, adventure)
- `difficulty`: Game difficulty (peaceful, easy, normal, hard)
- `max-players`: Maximum number of players
- `allow-cheats`: Enable/disable cheats
- `server-port`: Server port (default: 19132)
- `server-portv6`: IPv6 server port (default: 19133)

## Accessing the Server Console

To access the server console for commands:

```bash
# Using docker-compose
docker-compose exec bedrock-server /bin/bash

# Using docker directly
docker exec -it minecraft-bedrock /bin/bash
```

## Backup and Restore

### Backup Worlds

```bash
# Create backup of world data
tar -czf backup-$(date +%Y%m%d-%H%M%S).tar.gz data/
```

### Restore Worlds

```bash
# Stop the server
docker-compose down

# Extract backup
tar -xzf backup-YYYYMMDD-HHMMSS.tar.gz

# Start the server
docker-compose up -d
```

## Volume Mounts

- `/minecraft-bedrock/worlds`: World save data
- `/minecraft-bedrock/config`: Server configuration files

## Environment Variables

- `LD_LIBRARY_PATH`: Set to current directory (.) for proper library loading
