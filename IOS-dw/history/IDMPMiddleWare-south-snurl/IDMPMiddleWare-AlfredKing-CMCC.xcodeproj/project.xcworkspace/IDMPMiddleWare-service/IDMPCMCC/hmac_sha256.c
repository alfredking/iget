/*
  * Copyright (c) 2008 SINA Corporation, All Rights Reserved.
  *      Authors: Spark Zheng <zhengyu@staff.sina.com.cn>
  *
  *      hmac_sha256.c
  *      hmac-sha256 algorithm implementation
  *
  */
#include <string.h>
#include <stdint.h>
#include "hmac.h"
#include "sha256.h"
#define IPAD 0x36
#define OPAD 0x5c
	int hmac_sha256(const void *key, size_t key_len, const void *data, size_t data_len, void *ret_buf) {
		uint32_t i;
		struct sha256_ctx inner;
		struct sha256_ctx outer;
		struct sha256_ctx key_hash;
		char ipad[64] = {0};
		char opad[64] = {0};
		char key_buf[SHA256_DIGEST_SIZE] = {0};
		char inner_buf[SHA256_DIGEST_SIZE] = {0};
		if (key == NULL || data == NULL || ret_buf == NULL)
			return -1;
		/*
			in hmacsha256.js, key_len : 16 * 4 = 64
		*/
		if (key_len > 64) {
			sha256_init_ctx(&key_hash);
			sha256_process_bytes(key, key_len, &key_hash);
			sha256_finish_ctx(&key_hash, key_buf);
			key = key_buf;
			key_len = SHA256_DIGEST_SIZE;
		}
		sha256_init_ctx (&inner);
		for (i = 0; i < 64; i++) {
			if (i < key_len) {
				ipad[i] = ((const char *)key)[i] ^ IPAD;
				opad[i] = ((const char *)key)[i] ^ OPAD;
			} else {
				ipad[i] = IPAD;
				opad[i] = OPAD;
			}
		}
		sha256_process_block (ipad, 64, &inner);
		sha256_process_bytes (data, data_len, &inner);
		sha256_finish_ctx (&inner, inner_buf);
		sha256_init_ctx (&outer);
		sha256_process_block (opad, 64, &outer);
		sha256_process_bytes (inner_buf, SHA256_DIGEST_SIZE, &outer);
		sha256_finish_ctx (&outer, ret_buf);
		return 0;
	}
