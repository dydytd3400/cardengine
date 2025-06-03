## 随机唯一ID生成
class_name UUID
extends Object

## 生成符合 RFC 4122 标准的 UUID v4
static func generate() -> String:
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var bytes = []
	# 生成 16 个随机字节
	for i in range(16):
		bytes.append(rng.randi_range(0, 255))

	# 设置版本号 (第 7 字节高位设为 0100)
	bytes[6] = (bytes[6] & 0x0F) | 0x40
	# 设置变体 (第 9 字节高位设为 10)
	bytes[8] = (bytes[8] & 0x3F) | 0x80

	# 转换为十六进制字符串
	var hex_chars = []
	for i in range(16):
		hex_chars.append("%02x" % bytes[i])

	# 格式化为标准 UUID 格式
	return "%s%s%s%s-%s%s-%s%s-%s%s-%s%s%s%s%s%s" % hex_chars
