# Checkmate – Uptime Monitor

[Checkmate](https://github.com/bluewave-labs/checkmate) is a self-hosted, open-source uptime and infrastructure monitoring platform.

## Features

- 🌐 Monitor HTTP/HTTPS endpoints, TCP ports, and more
- 📊 Real-time dashboard with response time graphs
- 🔔 Incident alerts (email, Slack, webhooks)
- 🗄️ Built-in MongoDB – no external database needed

## Configuration

| Option | Default | Description |
|---|---|---|
| `jwt_secret` | `change_me_please` | **Change this!** Secret used to sign auth tokens |
| `mongodb_port` | `27017` | Internal MongoDB port (usually no need to change) |

> ⚠️ **Always set a strong `jwt_secret` before first start.**

## Access

After starting, the Checkmate UI is available:

- Via the **Home Assistant sidebar** (Ingress)
- Directly at `http://<your-ha-ip>:52345`

## Data persistence

All data (MongoDB database) is stored in `/data/mongodb` inside the add-on's
persistent storage – it survives restarts and updates.

## Support

- [Checkmate GitHub](https://github.com/bluewave-labs/checkmate)
- [Add-on repository issues](https://github.com/DaHofa02/dahofa-ha-addons/issues)
