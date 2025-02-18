import requests
import json

# Use the provided API key (in practice, keep your API keys secure)
API_KEY = "AIzaSyACiBLwDTB6okbGRkMe-omeJCNAP_IoqAk"
API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

def generate_paragraph(prompt):
    """
    Sends a POST request to the LLM API with the given prompt and returns the generated text.
    """
    headers = {
        "Content-Type": "application/json"
    }
    payload = {
        "contents": [{
            "parts": [{"text": prompt}]
        }]
    }
    params = {
        "key": API_KEY
    }
    response = requests.post(API_URL, headers=headers, params=params, json=payload)
    if response.status_code == 200:
        data = response.json()
        # Assumes the API response includes a 'candidates' key with the generated text.
        if "candidates" in data and data["candidates"]:
            return data["candidates"][0].get("output", "")
    else:
        print("API error:", response.text)
    return ""

def generate_story():
    """
    Iteratively builds a story by generating paragraphs one after another.
    """
    story = ""
    # Start with an initial prompt for a mystery story.
    prompt = "Write the opening paragraph of a thrilling mystery story."
    num_iterations = 5  # Adjust number of iterations for desired story length
    
    for i in range(num_iterations):
        print(f"Generating paragraph {i+1}...")
        paragraph = generate_paragraph(prompt)
        if paragraph:
            # Append the paragraph wrapped in HTML paragraph tags.
            story += f"<p>{paragraph}</p>\n"
            # Modify the prompt for the next iteration to continue the story.
            # For a real scenario, you might extract key context or summary.
            snippet = paragraph[-100:]  # last 100 characters as context
            prompt = f"Continue the story from this: {snippet}"
        else:
            print("No response received; stopping generation.")
            break
    return story

def create_webpage(story):
    """
    Assembles the story into a complete HTML document and writes it to a file.
    """
    html_content = f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Generated Mystery Story</title>
</head>
<body>
    <h1>Mystery Story</h1>
    {story}
</body>
</html>"""
    with open("story.html", "w", encoding="utf-8") as file:
        file.write(html_content)
    print("Story generated and saved to story.html")

if __name__ == "__main__":
    story = generate_story()
    create_webpage(story)
