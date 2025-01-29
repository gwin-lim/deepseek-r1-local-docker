
# Monitor in real-time
echo "Monitoring TCP connections..."
sudo tail -f /var/log/syslog | grep "Model Container"