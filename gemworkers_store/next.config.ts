import type { NextConfig } from "next";

// Short, clean links for social bios: gemworkers.com/tiktok → homepage with
// ?utm_source=tiktok, so the dashboard still counts where visitors came from.
const SOCIAL = ['tiktok', 'instagram', 'facebook', 'youtube', 'whatsapp', 'pinterest'];

const nextConfig: NextConfig = {
  async redirects() {
    return SOCIAL.map(s => ({ source: `/${s}`, destination: `/?utm_source=${s}`, permanent: false }));
  },
};

export default nextConfig;
