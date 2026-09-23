import { ChatSessionBlueprint } from '../@api/v9';

export default {
    
    // API version
    version: 9,

    // Unique name used to identify the blueprint and to overwrite a built-in or custom blueprint
    name: 'Create Virtual Interface',

    // The assistant's reply to the blueprint's messages will target the chat
    target: 'chat',

    // The canonical name or id of the used profile. If the specified profile is not found, a default one will be used.
    profile: 'Basic',

    // The messages (requests and replies) used to create the new session:
    // - At least one message must be present
    // - User and assistant messages must alternate
    // - Sessions started from this blueprint will automatically pull a reply from the LLM when the last message is a user message
    messages: [
        {
            role: 'user',
            content: {
                type: 'text',
                text: `Act as an @language engineer, with vast experience in Design and Verification.
Task: Tie up a new virtual interface into the testbench top of your project, for the given module.

Follow these steps:
1. Define an interface suitable for monitoring the given module. Add ports and include them into clocking blocks.
2. Instantiate and connect the interface in the testbench. Make sure to **connect all the signals** of the interface. Do not use placeholders.
3. Appropriately set the virtual interface reference in the uvm_config_db. Make sure to output only the uvm_config_db::set function call.

IMPORTANT:
- Output only the new sections of code.

Module to create virtual interface for:
\`\`\`
@selected module
\`\`\`

Testbench:
\`\`\`
#apb_subsystem_top
\`\`\`

Testbench design hierarchy:
\`\`\`
@design hierarchy
\`\`\``
            }
        }
    ]

} satisfies ChatSessionBlueprint;
