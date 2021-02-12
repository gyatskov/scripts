{
    "ignore_unmatched_nodes": true,
    "global_false_positives": {
        "false_fixed_substrings": [ ],
        "false_patterns": [ ],
        "problem_matchers": ["[eE]rror|ERROR: (.+)$"]
    },
    "nodes": [
    {
        "node_name": "root",
        "false_fixed_substrings": [
            "randomlyfailingtool++: error: connection timeout",
            "sporadiouslyfailingtest: error: 1 > 2",
            "downloadtool: File not found"
        ],
        "false_patterns": [ ],
        "problem_matchers": ["error: (.+)$", "Error ([[:digit:]]+)(.+)$"]
    },
    {
        "node_name": "experimental_tests",
        "false_fixed_substrings": [ ],
        "false_patterns": [ ],
        "problem_matchers": []
    },
    {
        "node_name": "experimental_windows_build",
        "false_fixed_substrings": [ "An unexpected error occured" ],
        "false_patterns": [ "Windows .+\.exe crashed" ],
        "problem_matchers": ["Error: (.+)$"]
    }
    ]
}
