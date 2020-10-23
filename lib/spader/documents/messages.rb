module Spader
  class Messages < Document
    def self.generate(project_title)
      messages = Messages.new()
      
      messages.document = {
        "appName" => {
          "message" => project_title,
        },
        "appDesc" => {
          "message" => "This is a WebExtension project."
        }
      }
      
      return messages
    end
  end
end