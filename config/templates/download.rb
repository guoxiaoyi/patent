require 'docx'

def extract_placeholders(doc_path)
  placeholders = []
  
  # 打开 Word 文件
  doc = Docx::Document.open(doc_path)
  
  # 遍历所有段落，查找包含 `{{...}}` 的文本
  doc.paragraphs.each do |paragraph|
    paragraph.text.scan(/\{\{(.*?)\}\}/).each do |match|
      placeholders << match[0].strip
    end
  end

  placeholders
end

# 示例调用
doc_path = 'write_application.docx'
placeholders = extract_placeholders(doc_path)
puts "找到的占位符: #{placeholders}"
