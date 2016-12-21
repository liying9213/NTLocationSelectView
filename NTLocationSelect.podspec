Pod::Spec.new do |s|
    s.name         = 'NTLocationSelect'
    s.version      = '1.0'
    s.summary      = 'NTLocationSelect is a shipping address selector.'
    s.homepage     = 'https://github.com/liying9213/NTLocationSelectView'
    s.license      = 'MIT'
    s.authors      = { 'liying' => 'tiantian9213@gmail.com' }
    #s.platform     = :ios, '7.0'
    s.ios.deployment_target = '7.0'
    s.source       = { :git => 'https://github.com/liying9213/NTLocationSelectView.git', :tag => s.version.to_s }
    s.source_files = 'NTLocationSelectView/locationSelectView/**/*.{h,m}'
    s.resource     = 'NTLocationSelectView/locationSelectView/**/NTLocation.bundle'
    s.framework    = 'UIKit'
    s.library = 'sqlite3'
    s.dependency 'FMDB'
    s.dependency 'Masonry'
    s.requires_arc = true
end