function FindProxyForURL(url, host) {
  if (dnsDomainIs(host, "ackerspace.com"))
    return "SOCKS5 127.0.0.1:1055";
  if (dnsDomainIs(host, "whatsapp.com"))
    return "SOCKS5 127.0.0.1:1055";
  if (dnsDomainIs(host, "telegram.org"))
    return "SOCKS5 127.0.0.1:1055";
  if (dnsDomainIs(host, "linkedin.com"))
    return "SOCKS5 127.0.0.1:1055";
  if (shExpMatch(host, "*.rtbf.be"))
    return "SOCKS5 127.0.0.1:1055";
  if (shExpMatch(host, "*.auvio.rtbf.be"))
    return "SOCKS5 127.0.0.1:1055";
  // return "SOCKS5 127.0.0.1:8080";
  return "DIRECT";
}
