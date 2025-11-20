@echo off
echo Building Minecraft Bedrock Server Docker Image...

REM Build the Docker image
docker build -t minecraft-bedrock-server:latest .

if %errorlevel% equ 0 (
    echo ✅ Docker image built successfully!
    echo.
    echo To run the server, use one of these commands:
    echo.
    echo Using Docker Compose ^(recommended^):
    echo   docker-compose up -d
    echo.
    echo Using Docker directly:
    echo   docker run -d --name minecraft-bedrock -p 19132:19132/udp -p 19133:19133/udp minecraft-bedrock-server:latest
    echo.
) else (
    echo ❌ Failed to build Docker image!
    exit /b 1
)