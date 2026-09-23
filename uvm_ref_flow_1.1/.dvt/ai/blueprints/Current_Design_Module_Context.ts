import { ChatSessionBlueprint } from '../@api/v9';

export default {
    
    // API version
    version: 9,

    // Unique name used to identify the blueprint and to overwrite a built-in or custom blueprint
    name: 'Current Design Module Context',

    // The assistant's reply to the blueprint's messages will target the chat
    target: 'chat',

    // The canonical name or id of the used profile. If the specified profile is not found, a default one will be used.
    profile: 'Agentic',

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

Output rules:
- Output only the sections of code that need to be added and their insertion points.

Use the following context for solving the task and wait for the task in the next prompt.

Working Module:
\`\`\`
@selected module
\`\`\`

Design hierarchy of the working module:
\`\`\`
@design hierarchy
\`\`\``
            }
        },
        {
            role: 'assistant',
            content: {
                type: 'text',
                text: `Please provide the specific task or modifications you need for the working module so that I can assist with the necessary code additions and their insertion points.`
            }
        }
    ]

} satisfies ChatSessionBlueprint;
