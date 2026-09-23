import { ChatSessionBlueprint } from '../@api/v9';

// Go to uvm_ref_flow_1.1/soc_verification_lib/sv_cb_ex_lib/uart_ctrl/sv/uart_ctrl_reg_model.sv
// Select the IPXACT comment and the ua_ier_c stub before running

export default {
    
    // API version
    version: 9,

    // Unique name used to identify the blueprint and to overwrite a built-in or custom blueprint
    name: 'Create UVM Register in Chat',

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
                text: `Based on the following IPXACT register specification, generate the UVM register class definition.
    
Rules:
- Add covergroups for read and write operations
- Generate the entire register class code, including the build() function override and the configuration of each field


Register Specification:
\`\`\`
@selected code
\`\`\`

uvm_reg class:
\`\`\`
@outline of #uvm_reg
\`\`\`

uvm_reg_field class:
\`\`\`
@outline of #uvm_reg_field
\`\`\`
`
            }
        }
    ]

} satisfies ChatSessionBlueprint;
