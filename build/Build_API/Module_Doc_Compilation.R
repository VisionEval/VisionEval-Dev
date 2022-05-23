# Scan for inst/module_docs, render as HTML, make an index page, and put in a common location.
# For .Rmd files, use the already-rendered .html versions which have been provided

# Setup ----
library(rmarkdown)

base_ve = '~/git/VisionEval-Dev'
output_dir = file.path(base_ve, 'Module_Docs')

if(!dir.exists(output_dir)) { dir.create(output_dir) }

# Search for files ----

all_dirs <- list.dirs(path = base_ve)

doc_dirs <- all_dirs[grep('module_docs$', all_dirs)]

modules <- unlist(strsplit(doc_dirs, '/'))
modules <- modules[grepl('^VE', modules)] 

# Make a list of docs in each module

module_compile <- vector()

for(d in 1:length(doc_dirs)){
  # d = 1
  dir_contents <- dir(doc_dirs[d])
  dir_contents <- dir_contents[grepl('md$', dir_contents)]
  module_compile <- rbind(module_compile, data.frame(Module = modules[d], Module_Doc = dir_contents))
  
    for(m in dir_contents){
      # m = dir_contents[1]
      
      if(grepl('Rmd$', m)){
        html_version = unlist(lapply(strsplit(m, '\\.'), function(x) x[[1]]))
        html_version = paste0(html_version, '.html')
        
        file.copy(from = file.path(doc_dirs[d], html_version),
                  to = output_dir)
        
        
      } else {
        render(input = file.path(doc_dirs[d], m),
               output_format = 'html_document',
               output_dir = output_dir)
        
      }
      
      
    }
}


# Make index page ----

# Provide list of module docs for the index
write.csv(module_compile, file = file.path(output_dir, 'Module_Compile_for_Index.csv'), row.names = F)

# Render the index page

render(input = 'Index_Compile.Rmd',
       output_format = 'html_document',
       output_dir = output_dir)


