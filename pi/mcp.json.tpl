// MCP server configuration for pi-mcp-extension.
// Render into $PI_CODING_AGENT_DIR/mcp.json with: pi.mcp-render
//
// 1Password references (op://) are safe to commit; secrets are resolved at
// render time. Add servers below and re-run pi.mcp-render to apply.
{
    "settings": {
        "toolPrefix": "mcp",
        "requestTimeoutMs": 30000,
        "maxRetries": 5
    },
    "mcpServers": {
        // Example HTTP/SSE server (streamable-http transport):
        // "my-http-server": {
        //     "transport": "streamable-http",
        //     "url": "https://example.com/mcp",
        //     "lifecycle": "eager",
        //     "headers": {
        //         "Authorization": "Bearer op://Personal/my-mcp-server/token"
        //     }
        // },
        //
        // Example stdio server (npm package):
        // "my-stdio-server": {
        //     "command": "npx",
        //     "args": ["-y", "some-mcp-server@latest"],
        //     "env": {
        //         "API_TOKEN": "op://Personal/my-mcp-server/api-token"
        //     }
        // }
    }
}
