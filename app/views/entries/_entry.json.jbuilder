json.id entry.id
json.title entry.title
json.tags entry.tags
json.description entry.description
json.video_size "#{(entry.video.size / 1024.0 / 1024.0).round(2)} MB"
json.video_duration "#{(entry.video.meta['duration']).to_i}"
json.video_url asset_url(entry.video.url(:mobile))
json.thumbnail_url asset_url(entry.video.url(:thumb))
