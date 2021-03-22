#
#  Be sure to run `pod spec lint BLAPIManagers.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "BNRMonitor"
  s.version      = "1.0.0"
  s.summary      = "BNRMonitor."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                    this is BNRMonitor
                   DESC

  s.homepage     = "https://www.lifestyle1.cn"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  # s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "JustinYang" => "ityangjing@gmail.com" }
  # Or just: s.author    = “JustinYang”

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  s.platform     = :ios, "10.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/JustinYangJing/Monitor.git", :tag => s.version.to_s }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.subspec 'Monitor' do |s1|
  	s1.source_files  = "TextureRender/Monitor/**/*.{h,m,mm}"
    s1.public_header_files = "TextureRender/Monitor/**/*.h"
  end

  s.subspec 'Opengl' do |s1|
  	s1.source_files  = "TextureRender/Opengl/*.{hpp,cpp}"
    s1.public_header_files = "TextureRender/Opengl/*.hpp"
    s1.subspec 'glm' do |s2|
      s2.source_files  = "TextureRender/Opengl/glm/*.{hpp}"
      s2.public_header_files = "TextureRender/Opengl/glm/*.hpp"

      s2.subspec 'ext' do |s3|
        s3.source_files = "TextureRender/Opengl/glm/ext/*.{hpp,inl}"
        s3.public_header_files = "TextureRender/Opengl/glm/ext/*.{hpp,inl}"
      end

      s2.subspec 'simd' do |s3|
        s3.source_files = "TextureRender/Opengl/glm/simd/*.{hpp,inl}"
        s3.public_header_files = "TextureRender/Opengl/glm/simd/*.{hpp,inl}"
      end

      s2.subspec 'detail' do |s3|
        s3.source_files = "TextureRender/Opengl/glm/detail/*.{hpp,inl}"
        s3.public_header_files = "TextureRender/Opengl/glm/detail/*.{hpp,inl}"
      end

      s2.subspec 'gtc' do |s3|
        s3.source_files = "TextureRender/Opengl/glm/gtc/*.{hpp,inl}"
        s3.public_header_files = "TextureRender/Opengl/glm/gtc/*.{hpp,inl}"
      end

      s2.subspec 'gtx' do |s3|
        s3.source_files = "TextureRender/Opengl/glm/gtx/*.{hpp,inl}"
        s3.public_header_files = "TextureRender/Opengl/glm/gtx/*.{hpp,inl}"
      end
    end
  end


  #s.public_header_files = "TextureRender/Monitor/**/*.h","TextureRender/Opengl/**/*.{hpp,inl}"
  s.preserve_paths = "glm/**"
  s.requires_arc = true
end