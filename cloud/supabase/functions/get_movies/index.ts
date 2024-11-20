// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { corsHeaders } from '../_shared/cors.ts'
import { TMDBApiUrl  } from '../_shared/constants.ts'

console.log("Hello from Functions!")

Deno.serve(async (req) => {
       if (req.method === 'OPTIONS') {
         return new Response('ok', { headers: corsHeaders })
       }
try {

     const options = {
        method: 'GET',
        headers: {
          accept: 'application/json',
          Authorization: `Bearer ${Deno.env.get('TMDB_APIKEY')}`,
        },
      };

  const url = new URL(req.url);
    const watchProviders = url.searchParams.get('watch_providers');
    const region = url.searchParams.get('region');

    if (!watchProviders || !region) {
        return new Response(
          JSON.stringify({ error: "No watch providers or region specified" }),
          { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 }
        );
      }

   const queryParams = new URLSearchParams({
        with_watch_providers: watchProviders,
        watch_region: region
      });

    const response = await fetch(
      `${TMDBApiUrl}/3/discover/movie?${queryParams.toString()}`,
      options
    );
    const movies = await response.json();


    const data = {
      movies, // Return the list of titles
    };

    return new Response(JSON.stringify(data), {
      headers: {...corsHeaders,"Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Error fetching movies:", err);

    return new Response(
      JSON.stringify({ error: "Failed to fetch movies" }),
      { headers: {...corsHeaders, "Content-Type": "application/json" }, status: 500 }
    );
  }
});
