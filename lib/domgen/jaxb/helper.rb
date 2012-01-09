module Domgen
  module JAXB
    module Helper
      def namespace_annotation_parameter(element)
        return '' unless element.namespace
        ", namespace=\"#{element.namespace}\""
      end

      def jaxb_class_annotations(struct)
        s = ''
        s << "@javax.xml.bind.annotation.XmlAccessorType( javax.xml.bind.annotation.XmlAccessType.FIELD )\n"
        ns = namespace_annotation_parameter(struct.xml)
        s << "@javax.xml.bind.annotation.XmlRootElement( name = \"#{struct.xml.name}\"#{ns} )\n" if struct.top_level?
        s << "@javax.xml.bind.annotation.XmlType( name = \"#{struct.name}Type\", propOrder = {#{struct.fields.collect{|field| "\"#{field.name}\""}.join(", ")}}#{ns} )\n"
        s
      end

      def jaxb_field_annotation(field)
        ns = namespace_annotation_parameter(field.xml)
        if field.collection?
<<JAVA
   @javax.xml.bind.annotation.XmlElementWrapper( name = "#{Domgen::Naming.pluralize(field.xml.name)}", required = #{field.xml.required?}#{ns})
   @javax.xml.bind.annotation.XmlElement( name = "#{field.xml.name}" )
JAVA
        else
          "@javax.xml.bind.annotation.Xml#{field.xml.element? ? "Element" : "Attribute" }( name = \"#{field.xml.name}\", required = #{field.xml.required?}#{ns} )"
        end
      end
    end
  end
end
