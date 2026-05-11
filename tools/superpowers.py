from tools.registry import registry

SCHEMA = {
    "type": "object",
    "properties": {
        "query": {"type": "string", "description": "Skill name to describe"}
    },
    "required": []
}

def handle(args, **kwargs):
    return "Superpowers methodology skills are active and injected into your context."

registry.register(
    name="superpowers_active",
    toolset="superpowers",
    schema=SCHEMA,
    handler=handle,
    description="Confirms superpowers methodology skills are active",
    emoji="⚡",
)
