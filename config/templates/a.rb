require 'pandoc-ruby'
require 'docx'
require 'tempfile'

# Load the Word template
doc = Docx::Document.open('template.docx')

# Define your markdown content for each placeholder
markdown_content = {
  'content1' => "# Header 1\nThis is a **bold** text and a [link](https://example.com)",
  'content2' => "## Header 2\nHere is an *italic* word and a bullet point list:\n- Item 1\n- Item 2"
}

# Convert markdown to a temporary docx file using PandocRuby
def convert_markdown_to_docx(markdown_text)
  Tempfile.create(['markdown_content', '.docx']) do |temp_file|
    PandocRuby.convert(markdown_text, from: :markdown, to: :docx, output: temp_file.path)
    temp_file.path # Return the file path for later use
  end
end

# Read the text from the converted docx for insertion (you can customize this part)
def extract_text_from_docx(file_path)
  doc = Docx::Document.open(file_path)
  doc.paragraphs.map(&:to_s).join("\n") # Combine paragraphs for insertion
end

# Iterate through the paragraphs and replace placeholders with converted markdown content
doc.paragraphs.each do |para|
  if para.to_s.include?('{{content1}}')
    # Save the markdown as a temp docx and extract text for insertion
    para.text = para.text.gsub('{{content1}}', extract_text_from_docx(convert_markdown_to_docx(markdown_content['content1'])))
  elsif para.to_s.include?('{{content2}}')
    para.text = para.text.gsub('{{content2}}', extract_text_from_docx(convert_markdown_to_docx(markdown_content['content2'])))
  end
end

# Save the modified document as a new file
doc.save('/path/to/new_document.docx')