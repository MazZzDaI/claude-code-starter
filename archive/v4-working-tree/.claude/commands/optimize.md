---
description: Optimise code performance
---

Help optimise the performance of the specified code.

**Optimisation areas:**

## 1. React Performance

**Check:**
- [ ] No unnecessary re-renders
- [ ] Memoisation is used (`useMemo`, `useCallback`)
- [ ] Keys are used correctly in lists
- [ ] Whether React.memo can be used
- [ ] No objects/functions created during render

**Optimisations:**
```typescript
// ❌ Bad
function Component() {
  return <Child onClick={() => {}} data={{}} />
}

// ✅ Good
const EMPTY_DATA = {}
function Component() {
  const handleClick = useCallback(() => {}, [])
  return <Child onClick={handleClick} data={EMPTY_DATA} />
}
```

## 2. Database Queries

**Check:**
- [ ] Only the required fields are queried
- [ ] Indexes are used
- [ ] No N+1 problems
- [ ] Pagination is used
- [ ] There are limits on result sets

**Optimisations:**
```typescript
// ❌ Bad
const { data } = await supabase.from('chats').select('*')

// ✅ Good
const { data } = await supabase
  .from('chats')
  .select('id, title, created_at')
  .limit(20)
  .order('created_at', { ascending: false })
```

## 3. Bundle Size

**Check:**
- [ ] Dynamic imports are used
- [ ] No unnecessary dependencies
- [ ] Images are optimised
- [ ] Tree shaking is used

**Optimisations:**
```typescript
// ❌ Bad
import HeavyLibrary from 'heavy-library'

// ✅ Good
const HeavyLibrary = dynamic(() => import('heavy-library'), {
  loading: () => <Spinner />
})
```

## 4. Caching

**Check:**
- [ ] React cache is used
- [ ] Revalidation works correctly
- [ ] SWR/React Query is used
- [ ] Static data is cached

## 5. Network

**Check:**
- [ ] Similar requests are combined
- [ ] Parallel loading is used
- [ ] There is prefetching
- [ ] Response size is optimised

## 6. Images & Media

**Check:**
- [ ] next/image is used
- [ ] Image sizes are correct
- [ ] Lazy loading is used
- [ ] Formats are optimised (WebP)

**Optimisation process:**

1. **Measure:**
   - Use the React DevTools Profiler
   - Check the Network tab
   - Run Lighthouse
   - Measure execution time

2. **Find the bottleneck:**
   - What takes the most time?
   - Where are unnecessary computations happening?
   - Where are the slow queries?

3. **Optimise:**
   - Start with the slowest
   - Make one change at a time
   - Measure after each change

4. **Verify:**
   - Functionality is preserved
   - Performance has improved
   - No new problems

**Metrics to track:**
- First Contentful Paint (FCP)
- Largest Contentful Paint (LCP)
- Time to Interactive (TTI)
- Cumulative Layout Shift (CLS)
- Total Blocking Time (TBT)

**At the end, give:**
- A list of the problems found
- Optimisation priorities
- Expected improvement
- Concrete code for the changes
