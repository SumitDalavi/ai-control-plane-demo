import time
import json
import urllib.request
import datetime

def make_request(url, payload):
    req = urllib.request.Request(url, data=json.dumps(payload).encode('utf-8'), headers={'Content-Type': 'application/json'})
    start = time.time()
    try:
        with urllib.request.urlopen(req) as response:
            body = response.read()
            headers = response.headers
            status = response.status
    except urllib.error.HTTPError as e:
        body = e.read()
        headers = e.headers
        status = e.code
    except Exception as e:
        return {"error": str(e)}, 0, 500, {}
    end = time.time()
    
    return json.loads(body.decode('utf-8')) if body else {}, end - start, status, headers

print("Starting AI Control Plane Benchmark...")

results = {
    "timestamp": datetime.datetime.utcnow().isoformat() + "Z",
    "metrics": {
        "semantic_cache": {},
        "cost_router": {}
    }
}

# 1. Semantic Cache Test
cache_url = "http://localhost:4000/v1/chat/completions"
prompt = {"messages": [{"role": "user", "content": "What is the speed of light?"}]}

# Miss
_, duration_miss, _, headers_miss = make_request(cache_url, prompt)
# Hit
_, duration_hit, _, headers_hit = make_request(cache_url, prompt)

results["metrics"]["semantic_cache"] = {
    "cache_miss_latency_s": round(duration_miss, 4),
    "cache_hit_latency_s": round(duration_hit, 4),
    "latency_improvement_percent": round((duration_miss - duration_hit) / max(duration_miss, 0.0001) * 100, 2),
    "x_cache_hit_verified": headers_hit.get("X-Cache-Hit", "false") == "true"
}

# 2. Cost Router Test
router_url = "http://localhost:3002/v1/completions"
simple_prompt = {"prompt": "Say hello"}
complex_prompt = {"prompt": "Write a complete complex react application from scratch"}

body_simple, _, _, _ = make_request(router_url, simple_prompt)
body_complex, _, _, _ = make_request(router_url, complex_prompt)

results["metrics"]["cost_router"] = {
    "simple_prompt_model": body_simple.get("model", "unknown") if isinstance(body_simple, dict) else "unknown",
    "complex_prompt_model": body_complex.get("model", "unknown") if isinstance(body_complex, dict) else "unknown"
}

output_file = f"benchmarks/results_{int(time.time())}.json"
with open(output_file, "w") as f:
    json.dump(results, f, indent=2)

print(f"Benchmark completed successfully. Results saved to {output_file}")
