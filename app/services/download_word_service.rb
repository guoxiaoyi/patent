require 'pandoc-ruby'
require 'docx'

def insert_markdown_to_word(markdown_content, word_template_path, output_path, placeholder)
  # 使用 Pandoc 将 Markdown 转为 Word 格式（docx）
  word_content = PandocRuby.convert(markdown_content, from: :markdown, to: :docx)

  # 加载 Word 模板
  doc = Docx::Document.open(word_template_path)

  # 替换占位符为生成的 Word 内容
  doc.paragraphs.each do |p|
    if p.text.include?(placeholder)
      p.replace_text!(placeholder, word_content)
    end
  end

  # 保存修改后的文档
  doc.save(output_path)
end

# # 示例调用
# markdown_content = "# 这是一个标题\n\n这是一些内容。"
# insert_markdown_to_word(markdown_content, 'template.docx', 'output.docx', '{{CONTENT_PLACEHOLDER}}')
