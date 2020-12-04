AIWOW_DATA_HOME <- Sys.getenv('AIWOW_DATA_HOME')
# The S3 implementation.
# It relies on AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY being configured in the environment.
S3_BUCKET_NAME <- stringr::str_split(AIWOW_DATA_HOME, pattern = '/')[[1]][3]
.root <- stringr::str_split(AIWOW_DATA_HOME, pattern = '/')[[1]]
S3_ROOT <- paste(.root[4:length(.root)], collapse = '/')

log_read <- function(fname) message(paste0('Reading from S3: ', file.path(S3_ROOT, fname)))
log_write <- function(fname) message(paste0('Writing to S3: ', file.path(S3_ROOT, fname)))


s3_read_csv <- function(fname, ...) {
  log_read(fname)
  aws.s3::s3read_using(readr::read_csv,
                       object = file.path(S3_ROOT, fname),
                       bucket = S3_BUCKET_NAME,
                       ...)
}

s3_write_csv <- function(x, path, ...) {
  log_write(path)
  aws.s3::s3write_using(x, readr::write_csv,
                        object = file.path(S3_ROOT, path),
                        bucket = S3_BUCKET_NAME,
                        opts = list(headers = list('x-amz-server-side-encryption' = 'AES256')),
                        ...)
}

# write.csv() preserves quotes around character values
s3_write.csv <- function(x, path, ...) {
  log_write(path)
  aws.s3::s3write_using(x, utils::write.csv,
                        object = file.path(S3_ROOT, path),
                        bucket = S3_BUCKET_NAME,
                        opts = list(headers = list('x-amz-server-side-encryption' = 'AES256')),
                        ...)
}

s3_readRDS <- function(fname, ...) {
  log_read(fname)
  aws.s3::s3readRDS(bucket = S3_BUCKET_NAME,
                    object =  file.path(S3_ROOT, fname), 
                    ...) 
}

s3_saveRDS <- function(x, path, ...) {
  log_write(path)
  aws.s3::s3saveRDS(x, bucket = S3_BUCKET_NAME,
                    object =  file.path(S3_ROOT, path), # path should contain name of object in storage
                    headers = list('x-amz-server-side-encryption' = 'AES256'),
                    ...)
}

s3_read_excel <- function(fname, ...) {
  log_read(fname)
  aws.s3::s3read_using(readxl::read_excel,
                       object = file.path(S3_ROOT, fname),
                       bucket = S3_BUCKET_NAME,
                       ...)
}

s3_read_excel_with_sheets <- function(fname, sheets, ...) {
  log_read(fname)
  tmp <- tempfile(fileext = ".xlsx")
  r <- aws.s3::save_object(bucket = S3_BUCKET_NAME,
                           object =  file.path(S3_ROOT, fname), 
                           file = tmp)
  dplyr::bind_rows(lapply(sheets, function(x) readxl::read_excel(tmp, sheet = x, ...) %>% mutate(join_GxP = x))) 
}

s3_get_object <- function(path, fname, ...){
  log_read(fname)
  aws.s3::get_object(
    bucket = S3_BUCKET_NAME,
    object = file.path(S3_ROOT, path, fname),
    ...
  )
}

s3_put_object <- function(key, fname, ...){
  aws.s3::put_object(
    file = fname,
    bucket = S3_BUCKET_NAME,
    object = file.path(S3_ROOT, key), 
    verbose = TRUE, 
    header = c('x-amz-server-side-encryption' = 'AES256'))
}

s3_get_bucket_df <- function(max_return = NULL, prefix, ...){
  aws.s3::get_bucket_df(
    bucket = S3_BUCKET_NAME,
    max = max_return,
    prefix = file.path(S3_ROOT, prefix),
    ...
  )
}

s3_write_xlsx <- function(list_with_sheet_names, path, ...) {
  log_write(path)
  aws.s3::s3write_using(list_with_sheet_names, writexl::write_xlsx,
                        object = file.path(S3_ROOT, path),
                        bucket = S3_BUCKET_NAME,
                        opts = list(headers = list('x-amz-server-side-encryption' = 'AES256')),
                        ...)
}
s3_read_using <- function(fname, FUN, ...) {
  log_read(fname)
  aws.s3::s3read_using(FUN,
                       object = file.path(S3_ROOT, fname),
                       bucket = S3_BUCKET_NAME,
                       ...)
}

s3_list_files <- function(path, ...) {
  aws.s3::get_bucket_df(bucket = S3_BUCKET_NAME, 
                        prefix = file.path(S3_ROOT, path))$Key
}

s3_fread <- function(fname, ...) {
  log_read(fname)
  aws.s3::s3read_using(data.table::fread,
                       
                       
                       object = file.path(S3_ROOT, fname),
                       bucket = S3_BUCKET_NAME,
                       ...)
}

s3_fwrite <- function(x, fname, ...) {
  log_write(fname)
  aws.s3::s3write_using(x, data.table::fwrite,
                        object = file.path(S3_ROOT, fname),
                        bucket = S3_BUCKET_NAME,
                        opts = list(headers = list('x-amz-server-side-encryption' = 'AES256'),
                                    multipart = TRUE),
                        ...)
}

s3_get_versions_from_s3 <- function(FNAME) {
  
  library(magrittr)
  system(
    sprintf("aws s3api list-object-versions --bucket %s --prefix %s > 'versions.json'", 
            S3_BUCKET_NAME,
            file.path(S3_ROOT, FNAME)))
  
  
  vers <- RJSONIO::fromJSON('versions.json')
  versions <- vers$Versions %>% sapply(function(x) x$VersionId)
  names(versions) <- vers$Versions %>% sapply(function(x) x$LastModified)
  unlink('versions.json')
  return(versions)
}

s3_get_version_using <- function(FUN, FNAME, version) {
  
  tmp_file <- paste0('file_version.', tools::file_ext(FNAME))
  
  library(magrittr)
  system(
    sprintf("aws s3api get-object --bucket '%s' --key '%s' --version-id '%s' '%s'", 
            S3_BUCKET_NAME,
            file.path(S3_ROOT, FNAME),
            version,
            tmp_file))
  
  obj_back <- FUN(tmp_file)
  unlink(tmp_file)
  return(obj_back)
}

s3_exists <- function(fname) {
  aws.s3::head_object(object = file.path(S3_ROOT, fname), bucket = S3_BUCKET_NAME) == TRUE
}

  