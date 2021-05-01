# Renderer cache

Currently we are generating everything on each `wb gen` call. This is a lot of
needless work that could've been avoided using a cache storing document
hashes so that only changed documents are rendered. 

See [[contribute|contribution guidelines]].
