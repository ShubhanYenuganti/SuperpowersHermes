_SCHEMA = {
    "type": "object",
    "properties": {
        "query": {"type": "string", "description": "Skill name to describe"}
    },
    "required": [],
}


def _handle(args, **kwargs):
    return "Superpowers methodology skills are active and injected into your context."


def register(ctx):
    """Register the superpowers toolset via the hermes plugin API."""
    ctx.register_tool(
        name="superpowers_active",
        toolset="superpowers",
        schema=_SCHEMA,
        handler=_handle,
        description="Confirms superpowers methodology skills are active",
        emoji="⚡",
    )
