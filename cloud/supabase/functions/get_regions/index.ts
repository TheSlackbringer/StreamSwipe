// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { corsHeaders } from '../_shared/cors.ts'
import { TMDBApiUrl  } from '../_shared/constants.ts'


Deno.serve(async (req) => {
       if (req.method === 'OPTIONS') {
         return new Response('ok', { headers: corsHeaders })
       }
try {
    const url = new URL(req.url);
    const region = url.searchParams.get('region') || 'US';

     const options = {
        method: 'GET',
        headers: {
          accept: 'application/json',
          Authorization: `Bearer ${Deno.env.get('TMDB_APIKEY')}`,
        },
      };

        const response = await fetch(`${TMDBApiUrl}/3/watch/providers/regions`, options);
        if (!response.ok) {
          throw new Error(`Failed to fetch regions: ${response.statusText}`);
        }
    const regions = await response.json();
    const regionMapping = regions.results.reduce((map: Record<string, string>, region: any) => {
      map[region.native_name] = region.iso_3166_1;
      return map;
    }, {});

    return new Response(JSON.stringify(regionMapping), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Error fetching regions:", err.message);

    return new Response(
      JSON.stringify({ error: "Failed to fetch regions", details: err.message }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 500 }
    );
  }
});