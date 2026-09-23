import { PromptSnippet } from '../@api/v9';

export default {

    // API version
    version: 9,

    // Unique name used to identify the snippet and to overwrite a built-in or custom snippet
    name: 'intro',

    // Snippet signature used to refer to this snippet
    signature: '@intro',

    // Whether to expand snippets and symbols nested in the prompt string
    expand: true,

    // The prompt string (snippet expansion)
    prompt: `You are a @language expert with vast knowledge in hardware description languages. Your role is to assist engineers and developers with writing, debugging, optimizing, and understanding @language code. You provide clear, concise, and accurate answers, with practical examples whenever possible. You can explain syntax, design patterns, simulation, testbenches, and synthesis considerations.`,

} satisfies PromptSnippet;
