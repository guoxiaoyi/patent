# app/services/docx_template_service.rb

require 'pandoc-ruby'
require 'zip'
require 'nokogiri'

class DocxTemplateService
  def initialize(template_path)
    @template_path = template_path
  end

  def generate_docx_with_markdown(markdown_content)
    # 将 Markdown 转换为 DOCX XML
    content_xml = markdown_to_docx_xml(markdown_content)

    # 在模板中插入内容
    output_path = insert_content_into_template(content_xml)

    # 返回生成的文件路径
    output_path
  end

  private

  def markdown_to_docx_xml(markdown_content)
    # 使用 Pandoc 将 Markdown 转换为 DOCX 格式
    docx_content = PandocRuby.convert(markdown_content, from: :markdown, to: :docx)
    puts docx_content.encoding
    # 将 DOCX 内容保存为临时文件
    Tempfile.create(['content', '.docx']) do |f|
      f.binmode  # 确保以二进制模式写入文件v
      f.write(docx_content)
      f.rewind
  
      # 解压 DOCX 文件并提取 word/document.xml
      Zip::File.open(f.path) do |zip_file|
        zip_file.get_entry('word/document.xml').get_input_stream.read
      end
    end
  end

  def insert_content_into_template(content_xml)
    # 生成输出文件路径
    output_path = Rails.root.join('tmp', "output_#{Time.now.to_i}.docx")

    # 读取模板 DOCX 文件
    Zip::File.open(@template_path) do |zip_file|
      # 读取模板的 document.xml
      document_xml = zip_file.get_entry('word/document.xml').get_input_stream.read
      doc = Nokogiri::XML(document_xml)

      # 找到占位符 {{CONTENT}}
      placeholder = doc.at_xpath("//w:t[text()='{{content2}}']", 'w' => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')
      puts "Placeholder found: #{!placeholder.nil?}"
      if placeholder
        # 插入新的内容（content_xml 中的 w:body 下的所有子节点）
        content_doc = Nokogiri::XML(content_xml)
        new_content = content_doc.at_xpath('//w:body', 'w' => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main').children
      
        # 将占位符所在的 w:p 元素替换为新内容
        parent = placeholder.at_xpath('ancestor::w:p', 'w' => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')
      
        if parent
          new_content.reverse_each do |node|
            parent.add_next_sibling(node)
          end
      
          parent.remove # 删除原占位符所在的段落
        else
          raise '未找到占位符的父级 w:p 元素'
        end
      else
        raise '占位符 {{CONTENT}} 未找到'
      end

      # 将修改后的 XML 写回到 DOCX 文件
      Zip::OutputStream.open(output_path) do |out|
        # 复制原始的 ZIP 文件（即 DOCX 文件）的所有内容，除了 document.xml
        zip_file.each do |entry|
          next if entry.name == 'word/document.xml'  # 跳过已被替换的 document.xml

          out.put_next_entry(entry.name)

          unless entry.directory?
            # 读取条目的内容并写入输出 ZIP 文件
            out.write zip_file.get_input_stream(entry.name) { |is| is.read }
          end
          # 如果是目录，则不需要写入内容
        end

        # 写入修改后的 document.xml
        out.put_next_entry('word/document.xml')
        out.write doc.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML)
      end
    end

    output_path
  end
end
