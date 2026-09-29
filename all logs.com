from pathlib import Path
import zipfile

root = Path("/mnt/data/alllogs_homepage")
root.mkdir(exist_ok=True)

html = r'''<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>AllLogs — Virtual Number Services</title>
  <meta name="description" content="AllLogs provides legitimate virtual and international phone-number services.">
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header class="nav">
    <a class="brand" href="#">All<span>Logs</span></a>
    <nav>
      <a href="#services">Services</a>
      <a href="#countries">Countries</a>
      <a href="#how">How it works</a>
      <a href="#support">Support</a>
    </nav>
    <a class="nav-btn" href="#numbers">View Numbers</a>
  </header>

  <main>
    <section class="hero">
      <div class="hero-copy">
        <div class="pill">● International number services</div>
        <h1>Stay connected <span>around the world.</span></h1>
        <p>Browse legitimate virtual-number services for supported countries, with clear pricing and straightforward ordering.</p>
        <div class="hero-actions">
          <a class="primary" href="#numbers">Browse numbers →</a>
          <a class="secondary" href="#how">How it works</a>
        </div>
        <div class="trust">
          <div><b>US · UK · CA</b><small>Supported regions</small></div>
          <div><b>Clear pricing</b><small>No hidden checkout surprises</small></div>
          <div><b>Support</b><small>Help when you need it</small></div>
        </div>
      </div>
      <div class="phone-card">
        <div class="phone-top"><span>AllLogs</span><span>•••</span></div>
        <div class="signal">+1 <strong>(555) 014-2086</strong></div>
        <div class="status">Available service</div>
        <div class="mini-row"><span>Country</span><b>🇺🇸 United States</b></div>
        <div class="mini-row"><span>Plan</span><b>30 days</b></div>
        <div class="price">$12.99</div>
        <a class="primary full" href="#numbers">Choose number</a>
      </div>
    </section>

    <section id="numbers" class="section">
      <div class="section-head">
        <div><p class="eyebrow">AVAILABLE SERVICES</p><h2>Choose a region</h2></div>
        <p>Availability and pricing can vary by number and service.</p>
      </div>
      <div class="cards" id="services">
        <article class="card"><div class="flag">🇺🇸</div><h3>United States</h3><p>Virtual number services for supported use cases.</p><div class="card-bottom"><b>From $12.99</b><button onclick="selectCountry('United States')">View</button></div></article>
        <article class="card"><div class="flag">🇬🇧</div><h3>United Kingdom</h3><p>International virtual-number options with transparent plans.</p><div class="card-bottom"><b>From $14.99</b><button onclick="selectCountry('United Kingdom')">View</button></div></article>
        <article class="card"><div class="flag">🇨🇦</div><h3>Canada</h3><p>Browse available Canadian virtual-number services.</p><div class="card-bottom"><b>From $13.99</b><button onclick="selectCountry('Canada')">View</button></div></article>
      </div>
    </section>

    <section id="how" class="section dark">
      <p class="eyebrow">HOW IT WORKS</p>
      <h2>Simple from start to finish.</h2>
      <div class="steps">
        <div><span>01</span><h3>Choose</h3><p>Select a supported country and service.</p></div>
        <div><span>02</span><h3>Checkout</h3><p>Review the plan and complete payment through your configured provider.</p></div>
        <div><span>03</span><h3>Receive</h3><p>Get your service details and support information.</p></div>
      </div>
    </section>

    <section id="countries" class="section faq">
      <p class="eyebrow">TRUST & SUPPORT</p>
      <h2>Built for clear, responsible service.</h2>
      <div class="notice">AllLogs should only be used for lawful purposes and in accordance with the terms of the services you use. We do not sell or promote access to other people's social-media accounts.</div>
      <div class="support" id="support">
        <div><h3>Need help?</h3><p>Connect your WhatsApp, email, or ticketing system here.</p></div>
        <a class="primary" href="mailto:support@alllogs.com">Contact support</a>
      </div>
    </section>
  </main>

  <footer>
    <b>AllLogs</b><span>© 2026 AllLogs. All rights reserved.</span>
  </footer>
  <script src="script.js"></script>
</body>
</html>'''

css = r'''*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,sans-serif;background:#f7f8fc;color:#111827}a{text-decoration:none;color:inherit}.nav{height:76px;padding:0 7%;display:flex;align-items:center;justify-content:space-between;background:#fff;border-bottom:1px solid #e8eaf0;position:sticky;top:0;z-index:5}.brand{font-size:25px;font-weight:900;letter-spacing:-1px}.brand span{color:#635bff}.nav nav{display:flex;gap:28px;color:#596174;font-size:14px}.nav-btn,.primary{background:#635bff;color:#fff;padding:13px 20px;border-radius:12px;font-weight:800;font-size:14px}.hero{max-width:1180px;margin:auto;padding:88px 28px 75px;display:grid;grid-template-columns:1.2fr .8fr;gap:70px;align-items:center}.pill{display:inline-block;background:#ecebff;color:#5148e8;border-radius:999px;padding:8px 13px;font-size:12px;font-weight:800;margin-bottom:20px}.hero h1{font-size:clamp(44px,6vw,72px);line-height:.98;letter-spacing:-4px;margin:0 0 22px}.hero h1 span{color:#635bff}.hero p{font-size:18px;line-height:1.7;color:#626b7d;max-width:620px}.hero-actions{display:flex;gap:12px;margin:28px 0}.secondary{padding:13px 20px;border:1px solid #dfe2ea;border-radius:12px;font-weight:800;background:#fff}.trust{display:flex;gap:25px;margin-top:38px}.trust div{border-left:2px solid #e3e5ed;padding-left:13px}.trust b{display:block;font-size:13px}.trust small{display:block;color:#7a8292;margin-top:4px}.phone-card{background:#111827;color:#fff;border-radius:30px;padding:27px;box-shadow:0 25px 70px #2c315230;min-height:380px;display:flex;flex-direction:column}.phone-top{display:flex;justify-content:space-between;color:#aeb6c7}.signal{font-size:25px;margin-top:62px}.signal strong{display:block;font-size:31px;margin-top:8px}.status{color:#72e6a1;font-size:13px;margin:12px 0 35px}.mini-row{display:flex;justify-content:space-between;border-top:1px solid #303847;padding:13px 0;color:#9da7b8;font-size:13px}.mini-row b{color:#fff}.price{font-size:28px;font-weight:900;margin:15px 0}.full{text-align:center}.section{max-width:1180px;margin:auto;padding:80px 28px}.section-head{display:flex;justify-content:space-between;align-items:end;margin-bottom:30px}.eyebrow{font-size:11px;font-weight:900;letter-spacing:1.8px;color:#635bff}.section h2{font-size:40px;letter-spacing:-2px;margin:8px 0 0}.section-head>p{color:#737b8d}.cards{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}.card{background:#fff;border:1px solid #e8eaf0;border-radius:20px;padding:24px}.flag{font-size:35px}.card h3{font-size:22px;margin:17px 0 8px}.card p{color:#71798a;line-height:1.6;min-height:52px}.card-bottom{border-top:1px solid #eceef3;padding-top:18px;margin-top:20px;display:flex;justify-content:space-between;align-items:center}.card button{border:0;background:#111827;color:#fff;border-radius:9px;padding:10px 15px;font-weight:800}.dark{max-width:none;background:#111827;color:#fff;padding-left:calc((100% - 1124px)/2);padding-right:calc((100% - 1124px)/2)}.dark .eyebrow{color:#9f99ff}.steps{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;margin-top:35px}.steps div{border:1px solid #303847;border-radius:18px;padding:24px}.steps span{color:#9f99ff;font-weight:900}.steps h3{font-size:21px}.steps p{color:#aeb6c7;line-height:1.6}.notice{background:#fff;border:1px solid #e4e6ed;padding:20px;border-radius:14px;color:#626b7d;line-height:1.6;margin-top:25px}.support{display:flex;justify-content:space-between;align-items:center;margin-top:22px;padding:25px;background:#fff;border:1px solid #e4e6ed;border-radius:18px}.support h3{margin:0 0 6px}.support p{margin:0;color:#727a8b}footer{padding:30px 7%;display:flex;justify-content:space-between;color:#777f90;border-top:1px solid #e5e7ed;background:#fff;font-size:13px}@media(max-width:800px){.nav nav{display:none}.hero{grid-template-columns:1fr;padding-top:55px;gap:35px}.trust{flex-direction:column;gap:12px}.cards,.steps{grid-template-columns:1fr}.section-head{display:block}.dark{padding-left:28px;padding-right:28px}.support{display:block}.support .primary{display:inline-block;margin-top:18px}footer{display:block}footer span{display:block;margin-top:8px}}'''

js = r'''function selectCountry(country){
  alert(country + " selected. Next step: connect your real inventory and checkout/payment provider.");
}'''

(root/"index.html").write_text(html, encoding="utf-8")
(root/"style.css").write_text(css, encoding="utf-8")
(root/"script.js").write_text(js, encoding="utf-8")

zip_path = Path("/mnt/data/AllLogs-homepage.zip")
with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
    for f in root.iterdir():
        z.write(f, f.name)

print(f"Created: {zip_path}")
